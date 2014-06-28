When(/I select the todo to be deleted/) do
  click_link('todo-delete-1')
end

Then(/I should receive a popup alert/) do
  find(:xpath, '//div[@id="delete-todo-modal"][@class="modal in"]')
end

And(/when I agree to delete the todo/) do
  click_link('delete-todo-button')
  page.driver.browser.switch_to.alert.accept
end

Then(/it should disappear from the todo list/) do
  find(:xpath, '//tr[@id="todo-row-1"][@class="hidden"]', visible: false)
end
