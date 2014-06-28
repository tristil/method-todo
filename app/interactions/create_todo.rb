class CreateTodo
  attr_accessor :description,
                :user

  def initialize(description: nil, user: nil)
    fail ArgumentError unless user
    self.description = description
    self.user = user
  end

  def call
    todo = Todo.new(description: description)
    todo.user = user
    todo.save!
    todo.parse
    todo
  end
end
