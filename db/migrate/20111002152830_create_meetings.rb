class CreateMeetings < ActiveRecord::Migration
  def self.up
    create_table :meetings do |t|
      t.string :subject
      t.string :location
      
      t.datetime :date
      t.datetime :time
      t.string :time_zone
      t.datetime :duration
      
      t.text :topics
      t.string :extra_info
      t.text :minutes

      t.timestamps
    end
  end
  
  def self.down
    drop_table :meetings
  end
end