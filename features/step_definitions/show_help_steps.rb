And(/I should see help text/) do
  page.should have_content('Assign the todo to a Context')
  find(:css, '#help-box').should be_visible
  page.should_not have_selector('#show-help-box')
end

When(/I dismiss the help text it should disappear/) do
  click_link('dismiss-help')
  page.should_not have_selector('#help-box')
  find(:css, '#show-help-box').should be_visible
end

When(/I return to the page it should be closed/) do
  visit(root_path)
  page.should_not have_selector('#help-box')
  find(:css, '#show-help-box').should be_visible
end
