class CreateTagTodoJoinTable < ActiveRecord::Migration
  def change
    create_table :tags_todos do |t|
      t.references :todo
      t.references :tag
    end

    add_index :tags_todos, [:tag_id, :todo_id]
    add_index :tags_todos, [:todo_id, :tag_id]
  end
end
