###
# Model for +Todo+ records
# - acts_as_paranoid

class Todo < ActiveRecord::Base
  # @!attribute description
  #   @return [String] text of the +Todo+

  # @!attribute completed
  #   @return [Boolean] Whether it is completed

  # @!attribute completed_time
  #   @return [Datetime] Time of completion

  acts_as_paranoid

  before_save :set_and_update_rankings, unless: :ranking

  validates :description, presence: true

  validates_uniqueness_of :ranking,
                          scope: [:user_id, :deleted_at],
                          if: :ranking

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
  PROJECT_REGEXP = /\+(.+?)(?: |$)/

  # Regexp for pulling +TodoContext+ out of description
  CONTEXT_REGEXP = /\@(.+?)(?: |$)/

  # Regexp for pulling +Tag+ out of description
  TAG_REGEXP = /\#(.+?)(?: |$)/

  scope :active, -> { where(completed: false, tickler: false) }
  scope :completed, -> { where(completed: true, tickler: false) }
  scope :ticklers, -> { where(tickler: true, completed: false) }

  # Scope todos for constrained set of options
  #   @return [Array<Todo>]
  def self.for_options(options = {})
    if options[:tickler]
      todos = ticklers.order('todos.ranking ASC')
    elsif options[:completed]
      todos = completed.order('todos.completed_time DESC')
    else
      todos = active.order('todos.ranking ASC')
    end

    if options[:context_id]
      todos = todos.includes(:todo_contexts)
        .where(todo_contexts: { id: options[:context_id] })
    end

    if options[:tag_id]
      todos = todos.includes(:tags).where(tags: { id: options[:tag_id] })
    end

    if options[:project_id]
      todos = todos.where(project_id: options[:project_id])
    end
    todos
  end

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

  # Mark the +Todo+ as for the 'tickler' file or not
  # @return [void]
  def toggle_tickler_status
    write_attribute(:tickler, !tickler)
  end

  # Mark the +Todo+ as 'starred' or not
  # @return [void]
  def toggle_starred_status
    write_attribute(:starred, !starred)
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
    timezone_offset = user.preferences[:timezone_offset] || 0
    completed_time.in_time_zone(timezone_offset)
  end

  # Parse description line to create +TodoContext+, +Project+ and +Tag+
  # associations. Must be run after the record is saved.
  # @return [void]
  def parse
    fail "Todo not assigned to a user, can't parse" unless user
    fail '#parse meant to be run after save' if new_record?

    match_data = PROJECT_REGEXP.match(description)
    if match_data
      name = match_data[1]
      project_exists = Project.where(name: name, user_id: user.id)
      if project_exists.blank?
        project = Project.new(name: name)
        project.user = user
        project.save!
      else
        project = project_exists.first
      end
      self.project = project
    else
      self.project = nil
    end

    self.todo_contexts = []
    match_data = description.scan(CONTEXT_REGEXP)
    if match_data
      match_data.each do |match|
        name = match[0]
        context_exists = TodoContext.where(name: name, user_id: user.id)
        if context_exists.blank?
          context = TodoContext.new(name: name)
          context.user = user
          context.save!
        else
          context = context_exists.first
        end
        todo_contexts << context
      end
    end

    self.tags = []
    match_data = description.scan(TAG_REGEXP)
    if match_data
      match_data.each do |match|
        name = match[0]
        tag_exists = Tag.where(name: name, user_id: user.id)
        if tag_exists.blank?
          tag = Tag.new(name: name)
          tag.user = user
          tag.save!
        else
          tag = tag_exists.first
        end
        tags << tag
      end
    end

    save!
  end

  def parse_description!
    new_description = description.dup

    PROJECT_REGEXP.match(description) do |match|
      new_description.gsub! ' +' + match[1], ''
      new_description +=
        " <a href='#' class='project-badge-#{project.id} todo-badge'>" \
        "<span class='label label-default'>+#{match[1]}</span></a>"
    end

    description.scan(CONTEXT_REGEXP) do |match|
      name = match[0].strip
      new_description.gsub! ' @' + name, ''
      context_id = todo_contexts.select do |todo_context|
        todo_context.name == name
      end.first.id
      new_description +=
        " <a href='#' class='context-badge-#{context_id} todo-badge'>" \
        "<span class='label label-default'>@#{name}</span></a>"
    end

    description.scan(TAG_REGEXP) do |match|
      name = match[0].strip
      new_description.gsub! ' #' + name, ''
      tag_id = tags.select { |tag| tag.name == name }.first.id
      new_description +=
        " <a href='#' class='tag-badge-#{tag_id} todo-badge'>" \
        "<span class='label label-default'>##{name}</span></a>"
    end

    if completed
      new_description +=
        " <span class='completed-badge label label-default label-inverse'>" \
        "#{local_completed_time.to_formatted_s(:american)}</span>"
    end

    new_description
  end

  # Get formatted line (with Bootstrap 'badges') to display in data-table
  # @return [String]
  def parsed_description
    parse_description!
  rescue
    parse
    # Try one more time
    parse_description!
  end

  # Remove a string from locally scoped Todos' descriptions
  # @param text [String]
  # @return [void]
  def self.strip_text!(text)
    all.each do |todo|
      todo.description = todo.description.gsub(text, '').gsub(/ +/, ' ').strip
      todo.save
    end
  end

  # Render the record as json
  # @param options [Hash]
  # @return [Hash]
  def as_json(_options = nil)
    {
      id: id,
      description: parsed_description,
      completed: completed,
      tickler: tickler,
      ranking: ranking,
      starred: starred
    }
  end

  private

  def set_and_update_rankings
    return unless user
    self.ranking = 0
    return unless Todo.where(ranking: 0, user_id: user.id).exists?

    Todo.where(user_id: user.id).update_all('ranking = ranking + 1')
  end
end
