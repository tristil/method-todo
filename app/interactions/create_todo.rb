class CreateTodo

  attr_accessor :todo_params,
                :user

  def initialize(todo_params: {}, user: nil)
    raise ArgumentError unless user
    self.todo_params = todo_params
    self.user = user
  end

  def call
    todo = Todo.new(todo_params)
    todo.user = user
    todo.save!
    todo.parse
    todo
  end

end
