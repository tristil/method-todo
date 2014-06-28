class AlterRankingColumn < ActiveRecord::Migration
  def up
    change_column :todos, :ranking, :integer, null: true

    add_index :todos, [:ranking, :deleted_at, :user_id], unique: true
  end

  def down
  end
end
