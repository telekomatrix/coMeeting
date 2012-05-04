class CreateConnections < ActiveRecord::Migration
  def self.up
    create_table :connections do |t|
      t.integer :user_id, :null => false
			t.integer :associate_id, :null => false

      t.timestamps
    end
    
    add_index :connections, :user_id
    add_index :connections, :associate_id
  end
  
  def self.down
    drop_table :connections
    
    remove_index :connections, :user_id
    remove_index :connections, :associate_id
  end
end
