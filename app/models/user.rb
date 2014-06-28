###
#  Model for +User+ records
#
#  - acts_as_paranoid
#  - devise: database_authenticatable
#  - devise: registerable
#  - devise: rememberable
#  - devise: trackable
#  - devise: validatable

class User < ActiveRecord::Base
  acts_as_paranoid

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable

  validates :username, presence: true, uniqueness: true

  # @!attribute todos
  #   @return [Array<Todo>]
  has_many :todos

  # @!attribute todo_contexts
  #   @return [Array<TodoContext>]
  has_many :todo_contexts

  # @!attribute projects
  #   @return [Array<Project>]
  has_many :projects

  # @!attribute tags
  #   @return [Array<Tag>]
  has_many :tags

  serialize :preferences, Hash

  #  Get only active todos
  #   @return [Array<Todo>]
  def active_todos
    todos.active.order('created_at DESC')
  end

  # Get only completed todos
  #   @return [Array<Todo>]
  def completed_todos
    todos.completed.order('completed_time DESC')
  end

  # Get only tickler todos
  #   @return [Array<Todo>]
  def tickler_todos
    todos.ticklers.order('completed_time DESC')
  end

  # Get todos for user based on options
  #   @return [Array<Todo>]
  def todos_for_options(options)
    todos.for_options(options)
  end
end
