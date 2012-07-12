And /there exists a todo with description of "(.*?)"/ do |description|
  @todos ||= []
  todo = Todo.new :description => description
  todo.user = @user
  todo.save
  todo.parse
  @todos << todo
end

And /I select a (context|project) option of "(.*?)"/ do |type, name|
  dropdown_item = find(:xpath, "//ul[@class='dropdown-menu']/li/a[.='#{name}']")
  dropdown_item.click
end

Then /the (Active|Completed) Todos table should only contain "(.*?)"/ do |table_type, description|
  not_todo = @todos.select {|todo| todo.description != description }.first
  page.should_not have_xpath "//div[@id='#{table_type.downcase}-todos-list']/table/tbody//tr/span[@id='todo-#{not_todo.id}']"
  rows = all(:xpath, "//div[@id='#{table_type.downcase}-todos-list']/table/tbody//tr")
  rows.first.find('span').text.should == description
end

When /I click the All todos button/ do
  click_link('all-todos-button')
end

Then /the (Active|Completed) Todos table should contain "(.*?)"/ do |table_type, todo|
  find(:xpath, "//div[@id='#{table_type.downcase}-todos-list']/table/tbody//tr//td/span[contains(., '#{todo}')]")
end

And /the page should have an? '(.+?)' header/ do |header|
  find(:css, '#filter').should have_content "Showing: #{header} Todos"
end

And /the (context|project|tag) dropdown should read '(.+?)'/ do |type, label|
  find(:xpath, "//li[@id='#{type}-dropdown-navitem']/a[@class='dropdown-toggle']").should have_content(label)
end
