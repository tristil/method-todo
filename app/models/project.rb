###
#  Model for +Project+ records
#
#  - acts_as_paranoid

class Project < ActiveRecord::Base
  acts_as_paranoid

  # @!attribute todos
  #   @return [Array<Todo>]
  has_many :todos

  # @!attribute user
  #   @return [User]
  belongs_to :user

  # @!attribute name
  #   @return [String] The name of the +Project+
  attr_accessible :name

  validates :name, :presence => true

  # Render the record as json
  # @param options [Hash]
  # @return [Hash]
  def as_json options = nil
    {
      :id => self.id,
      :name => self.name
    }
  end

end
