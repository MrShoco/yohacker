class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :name
      t.string :logo
      t.string :uid, :null => false
      t.string :provider, :null => false

      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end
