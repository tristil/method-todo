And /there exists a todo with description of "(.*?)"/ do |description|
  @todos ||= []
  todo = Todo.new :description => description
  todo.user = @user
  todo.save
  todo.parse
  @todos << todo
end

And /I select a (context|project) option of "(.*?)"/ do |type, name|
  visit('/')
  dropdown_item = find(:xpath, "//ul[@class='dropdown-menu']/li/a[.='#{name}']")
  dropdown_item.click
end

Then /the Active Todos table should only contain "(.*?)"/ do |description|
  not_todo = @todos.select {|todo| todo.description != description }.first
  page.should_not have_xpath "//div[@id='active-todos-list']/table/tbody//tr/span[@id='todo-#{not_todo.id}']"
  rows = all(:xpath, "//div[@id='active-todos-list']/table/tbody//tr")
  rows.first.find('span').text.should == description
end

When /I click the All todos button/ do
  click_link('all-todos-button')
end

Then /the Active Todos table should contain "(.*?)"/ do |todo|
  find(:xpath, "//div[@id='active-todos-list']/table/tbody//tr//td/span[.='#{todo}']")
end
