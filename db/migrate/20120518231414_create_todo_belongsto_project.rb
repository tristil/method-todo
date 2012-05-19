class CreateTodoBelongstoProject < ActiveRecord::Migration
  def change
    change_table :todos do |t|
      t.references :project
    end
  end
end
