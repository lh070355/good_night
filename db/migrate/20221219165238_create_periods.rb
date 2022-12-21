class CreatePeriods < ActiveRecord::Migration[7.0]
  def change
    create_table :periods do |t|
      t.belongs_to :user, null: false
      # add indexes for sleep_time, wake_up_time, and duration because they are sorted a lot
      # in periods related APIs. Index can speed up querying sorted results.
      # sleep_time must exist in each record while wake_up_time and duration can be null at
      # first because they would be updated later
      t.datetime :sleep_time, null: false, index: true
      t.datetime :wake_up_time, index: true
      # duration in seconds. range for 3 bytes signed integer: [-(2 ^ 23) ~ 2 ^ 23 - 1]
      # 2 ^ 23 - 1 secs ~= 2330 hrs, which is enough for this application
      t.integer :duration, limit: 3, index: true

      t.timestamps
    end
  end
end
