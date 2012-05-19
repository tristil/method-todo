class CreateTodoContextJoinTable < ActiveRecord::Migration
  def change
    create_table :todo_contexts_todos do |t|
      t.references :todo
      t.references :todo_context
    end

    add_index :todo_contexts_todos, [:todo_id, :todo_context_id]
    add_index :todo_contexts_todos, [:todo_context_id, :todo_id]
  end
end
