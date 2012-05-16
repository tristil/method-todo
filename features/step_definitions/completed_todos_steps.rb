When /I click the Completed Todos Button/ do
  click_link('completed-todo-button')
end

Then /the completed todos list should appear/ do
  page.driver.evaluate_script("$('#completed-todos-list').is(':visible')").should == true
end

And /the completed todo should be present in it/ do
  find('#completed-todos-list').should have_content('A New Todo')
end
