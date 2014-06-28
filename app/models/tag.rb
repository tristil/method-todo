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

  validates :name, presence: true

  # Render the record as json
  # @param options [Hash]
  # @return [Hash]
  def as_json(_options = nil)
    {
      id: id,
      name: name
    }
  end
end
