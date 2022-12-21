class RelationsController < ApplicationController
  def create
    # use #require to check for missing parameters
    follower_id, followee_id = params.require([:follower_id, :followee_id])

    # #to_i for convert string id input to integer (e.g. "1".to_i == 1.to_i)
    # if follower_id.to_i == followee_id.to_i
    #   return render json: { error_msg: 'follower and followee cannot be the same' }, status: 400
    # end

    # if create duplicate relation, will raise ActiveRecord::RecordInvalid for fail in
    # uniqueness check
    User.find(follower_id).followees << User.find(followee_id)

    render status: :ok
  end

  def destroy
    follower_id, followee_id = params.require([:follower_id, :followee_id])

    Relation.destroy_by(followee_id: followee_id, follower_id: follower_id)

    render status: :ok
  end
end
