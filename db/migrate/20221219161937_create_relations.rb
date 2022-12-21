class CreateRelations < ActiveRecord::Migration[7.0]
  def change
    create_table :relations do |t|
      t.belongs_to :follower, null: false
      t.belongs_to :followee, null: false
      # can be discussed to add the following index or not.
      # pros: uniqueness to DB layer
      # cons: index consume storage, write operation in DB would be slower,
      # and uniqueness have been validated in the active record layer
      t.index [:follower_id, :followee_id], unique: true

      t.timestamps
    end
  end
end
