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

  # @!attribute email
  #   @return [String]
  attr_accessible :email

  # @!attribute password
  #   @return [String]
  attr_accessible :password

  # @!attribute password_confirmation
  #   @return [String]
  attr_accessible :password_confirmation

  # @!attribute remember_me
  #   @return [Boolean]
  attr_accessible :remember_me

  # @!attribute username
  #   @return [String]
  attr_accessible :username

  # @!attribute preferences
  #   @return [Hash] Stores +User+ preferences
  attr_accessible :preferences

  validates :username, :presence => true, :uniqueness => true

  # @!attribute todos
  #   @return [Array<Todo>]
  has_many :todos

  # @!attribute todo_contexts
  #   @return [Array<TodoContext>]
  has_many :todo_contexts, :order => 'name'

  # @!attribute projects
  #   @return [Array<Project>]
  has_many :projects, :order => 'name'

  # @!attribute tags
  #   @return [Array<Tag>]
  has_many :tags, :order => 'name'

  serialize :preferences, Hash

  #  Get only active todos
  #   @return [Array<Todo>]
  def active_todos
    todos.active.order("created_at DESC")
  end

  # Get only completed todos
  #   @return [Array<Todo>]
  def completed_todos
    todos.completed.order("completed_time DESC")
  end

  # Get todos for user based on options
  #   @return [Array<Todo>]
  def todos_for_options(options)
    todos.for_options(options)
  end
end
