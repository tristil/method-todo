When /I click the edit button/ do
  click_link "todo-edit-#{@todo.id}"
end

And /I enter a new description of "(.*?)"/ do |description|
  fill_in("todo-#{@todo.id}-description", :with => description)
end
