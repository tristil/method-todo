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

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

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

  # @!attribute active_todos
  #   @return [Array<Todo>] Get only active todos
  has_many :active_todos, :class_name => 'Todo', :conditions => {:completed => false}, :order => 'created_at desc'

  # @!attribute completed_todos
  #   @return [Array<Todo>] Get only completed todos
  has_many :completed_todos, :class_name => 'Todo', :conditions => {:completed => true}, :order => 'completed_time desc'

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
end
