When(/I click "Manage\.\.\." on the (Context|Project|Tag) menu/) do |filter_type|
  click_link filter_type
  find(:css, "#manage-#{filter_type.downcase}s").click
end

Then(/the filter management menu for (Context|Project|Tag)s should appear/) do |_filter_type|
  find(:xpath, '//div[@id="manage-filters-modal"][@class="modal in"]')
end

When(/I click the Delete Filter button for "(.*)"/) do |value|
  find(:css, '#main-manage-filters td', text: value).find(:xpath, '..')
    .find('.remove-filter-button').click
end

And(/I click the Delete All confirmation button/) do
  find(:css, '#remove-filter-button-final').click
  page.driver.browser.switch_to.alert.accept
  click_link 'Close'
end

Then(/the Remove Filter dialog should only show "(.*)"/) do |value|
  all(:css, '#main-manage-filters td.remove-filter-name').each do |td|
    td.should have_content(value)
  end
end
