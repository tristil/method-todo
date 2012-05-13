class AddActsAsParanoid < ActiveRecord::Migration
  def up
    change_table(:todos) do |t|
      t.datetime :deleted_at
    end
    change_table(:users) do |t|
      t.datetime :deleted_at
    end
  end

  def down
    remove_column :todos, :deleted_at
    remove_column :users, :deleted_at
  end
end
