class AddUsername < ActiveRecord::Migration
  def up
    change_table(:users) do |t|
      t.string :username, null: false, default: ''
    end
  end

  def down
    remove_column :users, :username
  end
end
