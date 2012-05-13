class Todo < ActiveRecord::Base
  attr_accessible :description, :completed, :completed_time

  validates :description, :presence => true

  belongs_to :user

  def complete
    write_attribute(:completed, true)
    write_attribute(:completed_time, Time.now)
  end
end
