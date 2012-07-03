###
# Model for +Todo+ records
# - acts_as_paranoid

class Todo < ActiveRecord::Base

  attr_accessible :description
  # @!attribute description
  #   @return [String] text of the +Todo+

  attr_accessible :completed
  # @!attribute completed
  #   @return [Boolean] Whether it is completed

  attr_accessible :completed_time
  # @!attribute completed_time
  #   @return [Datetime] Time of completion

  acts_as_paranoid

  validates :description, :presence => true

  # @!attribute user
  #   @return [User]
  belongs_to :user

  # @!attribute todo_contexts
  #   @return [Array<TodoContext>]
  has_and_belongs_to_many :todo_contexts

  # @!attribute tags
  #   @return [Array<Tag>]
  has_and_belongs_to_many :tags

  # @!attribute project
  #   @return [Project]
  belongs_to :project

  # Regexp for pulling +Project+ out of description
  @@project_regexp = /\+(.+?)( |$)/

  # Regexp for pulling +TodoContext+ out of description
  @@context_regexp = /\@(.+?)( |$)/

  # Regexp for pulling +Tag+ out of description
  @@tag_regexp = /\#(.+?)( |$)/

  cattr_accessor :project_regexp
  cattr_accessor :context_regexp
  cattr_accessor :tag_regexp

  # Mark the +Todo+ as completed
  # @return [void]
  def complete
    write_attribute(:completed, true)
    write_attribute(:completed_time, Time.now)
  end

  # Mark the +Todo+ as no longer complete
  # @return [void]
  def uncomplete
    write_attribute(:completed, false)
    write_attribute(:completed_time, 0)
  end

  # Get the first associated +TodoContext+
  # @return [TodoContext]
  # @return [nil]
  def todo_context
    todo_contexts.empty? ? nil : todo_contexts.first
  end

  # Get the completed time in the user's most recent timezone
  # @return [Datetime]
  def local_completed_time
    timezone_offset = self.user.preferences[:timezone_offset]
    timezone_offset = timezone_offset ? timezone_offset : 0
    self.completed_time.in_time_zone(timezone_offset)
  end

  # Parse description line to create +TodoContext+, +Project+ and +Tag+
  # associations. Must be run after the record is saved.
  # @return [void]
  def parse
    unless user
      raise "Todo not assigned to a user, can't parse"
    end

    if new_record?
      raise ".parse meant to be run after save"
    end

    if match_data = self::project_regexp.match(description)
      name = match_data[1]
      project_exists = Project.where({:name => name, :user_id => user.id})
      unless project_exists.empty?
        project = project_exists.first
      else
        project = Project.new({:name => name})
        project.user = user
        project.save
      end
      self.project = project
    else
      self.project = nil
    end

    self.todo_contexts = []
    if match_data = description.scan(self::context_regexp)
      match_data.each do |match|
        name = match[0]
        context_exists = TodoContext.where({:name => name, :user_id => user.id})
        unless context_exists.empty?
          context = context_exists.first
        else
          context = TodoContext.new({:name => name})
          context.user = user
          context.save
        end
        self.todo_contexts << context
      end
    end

    self.tags = []
    if match_data = description.scan(self::tag_regexp)
      match_data.each do |match|
        name = match[0]
        tag_exists = Tag.where({:name => name, :user_id => user.id})
        unless tag_exists.empty?
          tag = tag_exists.first
        else
          tag = Tag.new({:name => name})
          tag.user = user
          tag.save
        end
        self.tags << tag
      end
    end

    self.save
  end

  # Get formatted line (with Bootstrap 'badges') to display in data-table
  # @return [String]
  def parsed_description
    begin
      new_description = description.dup

      Todo::project_regexp.match(self.description) do |match|
        new_description.gsub! ' +' + match[1], ''
        new_description += " <a href='#' class='project-badge-#{self.project.id} todo-badge'><span class='label'>+#{match[1]}</span></a>"
      end

      self.description.scan(Todo::context_regexp) do |match|
        name = match[0].strip
        new_description.gsub! ' @' + name, ''
        context_id = self.todo_contexts.select {|todo_context| todo_context.name == name }.first.id
        new_description += " <a href='#' class='context-badge-#{context_id} todo-badge'><span class='label'>@#{name}</span></a>"
      end

      self.description.scan(Todo::tag_regexp) do |match|
        name = match[0].strip
        new_description.gsub! ' #' + name, ''
        tag_id = self.tags.select {|tag| tag.name == name }.first.id
        new_description += " <a href='#' class='tag-badge-#{tag_id} todo-badge'><span class='label'>##{name}</span></a>"
      end

      if self.completed
        new_description += " <span class='completed-badge label label-inverse'>#{self.local_completed_time.to_formatted_s(:american)}</span>"
      end

      new_description
    rescue
      self.parse
      # What could possibly go wrong?
      parsed_description
    end
  end

  # Render the record as json
  # @param options [Hash]
  # @return [Hash]
  def as_json options = nil
    {
      :id => self.id,
      :description => self.parsed_description,
      :completed => self.completed
    }
  end
end
