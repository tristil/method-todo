class AddTicklerColumnToTodos < ActiveRecord::Migration
  def change
    change_table(:todos) do |t|
      t.column :tickler, :boolean, default: false
    end
  end
end
