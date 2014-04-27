class AddRankingToTodos < ActiveRecord::Migration
  def change
    change_table :todos do |t|
      t.column :ranking, :integer, null: false
    end
  end
end
