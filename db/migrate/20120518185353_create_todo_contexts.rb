class CreateTodoContexts < ActiveRecord::Migration
  def change
    create_table :todo_contexts do |t|
      t.string :name
      t.datetime :deleted_at
      t.references :user
      t.timestamps
    end
  end
end
