class Project < ActiveRecord::Base
  acts_as_paranoid

  has_many :todos
  belongs_to :user

  attr_accessible :name

  validates :name, :presence => true
end
