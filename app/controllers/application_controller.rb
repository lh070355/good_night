class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from ArgumentError, with: :argument_error
  rescue_from NoMethodError, with: :no_method_error
  # Whether rescue StandardError or not can be discussed
  # resource: https://guides.rubyonrails.org/action_controller_overview.html#rescue-from
  # "Using rescue_from with Exception or StandardError would cause serious side-effects
  # as it prevents Rails from handling exceptions properly. As such, it is not recommended
  # to do so unless there is a strong reason."
  # rescue_from StandardError, with: :general_error

  private

  def record_not_found(exception)
    # 'records with the parameters passed not found'
    render json: { error_msg: exception.message }, status: 400
  end

  def record_invalid(exception)
    # 'input validation failed, please check input restritions again'
    render json: { error_msg: exception.message }, status: 400
  end

  def parameter_missing
    render json: { error_msg: 'one or more paramters missing, please check again' }, status: 400
  end

  def argument_error
    render json: { error_msg: 'please check input type' }, status: 400
  end

  def no_method_error
    render json: { error_msg: 'please check input type' }, status: 400
  end

  # def general_error
  #   render plain: 'errors in server, please try again later', status: 500
  # end
end
