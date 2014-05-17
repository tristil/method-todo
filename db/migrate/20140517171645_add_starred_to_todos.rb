class AddStarredToTodos < ActiveRecord::Migration
  def change
    change_table :todos do |t|
      t.boolean :starred, null: false, default: false
    end
  end
end
