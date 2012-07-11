When /I click a badge for "(.*?)"/ do |badge_name|
  visit(root_path)
  find(:xpath, "//a[contains(@class, 'todo-badge')]/span[.='#{badge_name}']").click
end
