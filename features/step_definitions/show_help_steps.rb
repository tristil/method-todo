And /I should see help text/ do
  page.should have_content('Assign the todo to a Context')
  find(:css, '#help-box').should be_visible
  find(:css, '#show-help-box').should_not be_visible
end

When /I dismiss the help text it should disappear/ do
  click_link('dismiss-help')
  find(:css, '#help-box').should_not be_visible
  find(:css, '#show-help-box').should be_visible
end

When /I return to the page it should be closed/ do
  visit('/')
  find(:css, '#help-box').should_not be_visible
  find(:css, '#show-help-box').should be_visible
end
