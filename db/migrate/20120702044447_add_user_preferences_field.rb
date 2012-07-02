class AddUserPreferencesField < ActiveRecord::Migration
  def up
    change_table(:users) do |t|
      t.text :preferences
    end
  end

  def down
    remove_column :users, :preferences
  end
end
