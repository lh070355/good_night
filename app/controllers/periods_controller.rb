class PeriodsController < ApplicationController
  # post '/period'
  def create
    # use #require to check for missing parameters
    user_id = params.require(:user_id)
    # limit is an optional parameter for pagination, default value is 10
    results_limit = params.fetch(:limit, 10)
    user_periods = nil
    error_msg = nil

    ActiveRecord::Base.transaction do
      # find whether the user exists, if not raise ActiveRecord::RecordNotFound
      # lock for not reading same user's periods concurrently then create multiple new records
      user_periods = User.lock.find(user_id).periods
      latest_period = user_periods.order(:sleep_time).last
      current_time = DateTime.current
      # use safe navigation operator to filter out nil latest_period (e.g. 1st clock-in)
      if latest_period&.ongoing?(current_time)
        Rails.logger.error("User with id #{user_id} has one ongoing period")
        error_msg = 'You have one ongoing period'
        raise ActiveRecord::Rollback
      end

      # use #create! to raise an exception for invalid parameters
      user_periods.create!(sleep_time: current_time)
    end
    return render json: { error_msg: error_msg }, status: 400 if error_msg.present?

    render json: user_periods.order(:sleep_time).last(results_limit).pluck(:sleep_time)
  end

  # put '/latest_period'
  def update_latest_one
    user_id = params.require(:user_id)
    results_limit = params.fetch(:limit, 10)
    user_periods = nil
    error_msg = nil

    ActiveRecord::Base.transaction do
      user_periods = User.find(user_id).periods
      # use last! for raising ActiveRecord::RecordNotFound if doesn't find any record
      latest_period = user_periods.order(:sleep_time).last!
      # lock! for avoiding concurrent updating same record
      latest_period.lock!
      current_time = DateTime.current
      # return error message if the wake_up time of the last record is already clock-in or the sleep time
      # of it is over longest sleeping days
      unless latest_period.ongoing?(current_time)
        Rails.logger.error("User with id #{user_id} doesn't have one ongoing period")
        error_msg = 'You have already woken up'
        raise ActiveRecord::Rollback
      end

      # convert difference of 2 DateTime to UNIX time with #to_i. Use #update! for raising exception for invalid data
      latest_period.update!(wake_up_time: current_time, duration: current_time.to_i - latest_period.sleep_time.to_i)
    end
    return render json: { error_msg: error_msg }, status: 400 if error_msg.present?

    # TODO: check whether user_periods is updated with latest data
    render json: user_periods.order(:wake_up_time).where.not(wake_up_time: nil).last(results_limit).pluck(:wake_up_time)
  end

  # get '/followee/periods'
  def show_followee
    follower_id, followee_id = params.require([:follower_id, :followee_id])
    results_limit = params.fetch(:limit, 10)

    if follower_id.to_i == followee_id.to_i
      Rails.logger.error('follower and followee are the same')
      return render json: { error_msg: 'cannot see your own periods' }, status: 400
    end

    followee = User.find(follower_id).followees.find(followee_id)
    current_time = DateTime.current

    # render output with rails JSON serializer except id, created_at, updated_at because they are
    # internal data that user need not to know
    # exclude user_id for redudunt data
    render json: followee.periods
                         .order(:duration)
                         .where.not(duration: nil)
                         .where(sleep_time: current_time.prev_week...current_time.beginning_of_week)
                         .last(results_limit),
           except: [:id, :user_id, :created_at, :updated_at]
  end
end
