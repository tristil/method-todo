class User < ActiveRecord::Base
  acts_as_paranoid

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username

  validates :username, :presence => true, :uniqueness => true

  has_many :todos
  has_many :active_todos, :class_name => 'Todo', :conditions => {:completed => false}
  has_many :completed_todos, :class_name => 'Todo', :conditions => {:completed => true}

  has_many :todo_contexts
  has_many :projects
end
