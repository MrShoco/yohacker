class CreateTaskTags < ActiveRecord::Migration
  def up
    create_table :task_tags do |t|
      t.integer :task_id, :null => false
      t.string :title_rus, :null => false
      t.string :title_eng, :null => false

      t.timestamps
    end
  end

  def down
    drop_table :task_tags
  end
end
