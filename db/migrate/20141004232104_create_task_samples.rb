class CreateTaskSamples < ActiveRecord::Migration
  def up
    create_table :task_samples do |t|
      t.integer :task_id, :null => false
      t.text :input, :null => false, :limit => nil
      t.text :output, :null => false, :limit => nil

      t.timestamps
    end
  end

  def down
    drop_table :task_samples
  end
end
