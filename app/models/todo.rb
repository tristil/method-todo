class Todo < ActiveRecord::Base
  acts_as_paranoid

  attr_accessible :description, :completed, :completed_time, :project

  validates :description, :presence => true

  belongs_to :user

  has_and_belongs_to_many :todo_contexts
  has_and_belongs_to_many :tags
  belongs_to :project

  @@project_regexp = /\+(.+?)( |$)/
  @@context_regexp = /\@(.+?)( |$)/
  @@tag_regexp = /\#(.+?)( |$)/

  cattr_accessor :project_regexp
  cattr_accessor :context_regexp
  cattr_accessor :tag_regexp

  def complete
    write_attribute(:completed, true)
    write_attribute(:completed_time, Time.now)
  end

  def uncomplete
    write_attribute(:completed, false)
    write_attribute(:completed_time, 0)
  end

  def todo_context
    todo_contexts.empty? ? nil : todo_contexts.first
  end

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

  def parsed_description
    begin
      new_description = description.dup

      Todo::project_regexp.match(self.description) do |match|
        new_description.gsub! ' +' + match[1], ''
        new_description += " <a href='#' class='project-badge-#{self.project.id} todo-badge'><span class='label'>+#{match[1]}</span></a>"
      end

      description.scan(Todo::context_regexp) do |match|
        name = match[0].strip
        new_description.gsub! ' @' + name, ''
        context_id = self.todo_contexts.select {|todo_context| todo_context.name == name }.first.id
        new_description += " <a href='#' class='context-badge-#{context_id} todo-badge'><span class='label'>@#{name}</span></a>"
      end

      description.scan(Todo::tag_regexp) do |match|
        name = match[0].strip
        new_description.gsub! ' #' + name, ''
        tag_id = self.tags.select {|tag| tag.name == name }.first.id
        new_description += " <a href='#' class='tag-badge-#{tag_id} todo-badge'><span class='label'>##{name}</span></a>"
      end

      new_description
    rescue
      self.parse
      # What could possibly go wrong?
      parsed_description
    end
  end
end
