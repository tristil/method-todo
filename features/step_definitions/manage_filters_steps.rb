When /I click "Manage\.\.\." on the (Context|Project|Tag) menu/ do |filter_type|
  find(:css, "#manage-#{filter_type.downcase}s").click
end

Then /the filter management menu for (Context|Project|Tag)s should appear/ do |filter_type|
  popup = find(:xpath, '//div[@id="manage-filters-modal"][@class="modal in"]')
end
