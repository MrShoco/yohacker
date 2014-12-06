class CreateTasks < ActiveRecord::Migration
  def up
    create_table :tasks do |t|
      t.integer :task_id, :null => false
      t.text :title, :null => false, :limit => nil
      t.text :time_limit, :null => false, :limit => nil
      t.text :memory_limit, :null => false, :limit => nil
      t.text :statement, :null => false, :limit => nil
      t.text :input, :null => false, :limit => nil
      t.text :output, :null => false, :limit => nil
      t.integer :difficulty, :null => false

      t.timestamps
    end
  end

  def down 
    drop_table :tasks
  end
end
