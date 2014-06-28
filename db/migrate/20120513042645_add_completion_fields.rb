class AddCompletionFields < ActiveRecord::Migration
  def up
    change_table(:todos) do |t|
      t.boolean :completed, default: false
      t.datetime :completed_time
    end
  end

  def down
    remove_column :todos, :completed
    remove_column :todos, :completed_time
  end
end
