class CreateActionItems < ActiveRecord::Migration
  def self.up
    create_table :action_items do |t|
      t.integer :participation_id, :null => false
      
      t.string :todo
      t.string :deadline
      t.boolean :completed, :default => false, :null => false

      t.timestamps
    end
  end
  
  def self.down
    drop_table :action_items
  end
end
