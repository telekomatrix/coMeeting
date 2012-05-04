class CreateParticipations < ActiveRecord::Migration
  def self.up
    create_table :participations do |t|
      t.integer :user_id
			t.integer :meeting_id, :null => false
      
      t.string :link
      t.boolean :is_creator, :default => false, :null => false
      t.boolean :is_admin, :default => false, :null => false
      t.integer :is_attending, :default => 0, :null => false

      t.timestamps
    end
    
    add_index :participations, :user_id
    add_index :participations, :meeting_id
  end
  
  def self.down
    drop_table :participations
    
    remove_index :participations, :user_id
    remove_index :participations, :meeting_id
  end
end
