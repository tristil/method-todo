Then /I should see "(.*?)" and "(.*?)" in the "(.*?)" dropdown/ do |first_term, second_term, type|
  click_link type
  find(:xpath, "//li[@id='#{type.downcase}-dropdown-navitem']/ul/li/a[.='#{first_term}']")
  find(:xpath, "//li[@id='#{type.downcase}-dropdown-navitem']/ul/li/a[.='#{second_term}']")
end
