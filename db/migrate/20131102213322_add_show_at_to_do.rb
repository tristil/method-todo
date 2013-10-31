class AddShowAtToDo < ActiveRecord::Migration
  def change
    change_table(:todos) do |t|
      t.column :show_at, :datetime
    end
  end
end
