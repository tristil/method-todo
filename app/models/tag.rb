###
#  Model for +Tag+ records
#
#  - acts_as_paranoid

class Tag < ActiveRecord::Base
  acts_as_paranoid

  # @!attribute todos
  #   @return [Array<Todo>]
  has_and_belongs_to_many :todos

  # @!attribute user
  #   @return [User]
  belongs_to :user

  # @!attribute name
  #   @return [String] name of +Tag+
  attr_accessible :name

  validates :name, :presence => true
end
