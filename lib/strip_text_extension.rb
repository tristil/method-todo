module StripTextExtension

  # Remove a string from locally scoped Todos' descriptions
  # @param text [String]
  # @return [void]
  def strip_text! text
    all.each do |todo|
      todo.description = todo.description.sub(text, '').strip
      todo.save
    end
    all
  end

end
