class CreateRelations < ActiveRecord::Migration[7.0]
  def change
    create_table :relations do |t|
      t.belongs_to :follower, null: false
      t.belongs_to :followee, null: false
      # add the unique index to avoid creating duplicate data concurrently
      t.index [:follower_id, :followee_id], unique: true

      t.timestamps
    end
  end
end
