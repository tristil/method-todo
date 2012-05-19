module TodoHelper
  def parse_todo_description description
    new_description = description.dup

    Todo::project_regexp.match(description) do |match|
      new_description.gsub! ' +' + match[1], ''
      new_description += " <span class='label'>+#{match[1]}</span>"
    end

    description.scan(Todo::context_regexp) do |match|
      new_description.gsub! ' @' + match[0].strip, ''
      new_description += " <span class='label'>@#{match[0]}</span>"
    end

    new_description
  end
end
