class CreateSubmissions < ActiveRecord::Migration
  def up
    create_table :submissions do |t|
      t.integer :user_id, :null => false
      t.integer :task_id, :null => false
      t.text :code, :limit => nil 
      t.string :lang, :null => false
      t.string :result, :default => "Testing"

      t.timestamps
    end
  end

  def down
    drop_table :submissions
  end
end
