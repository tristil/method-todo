Before do
  DatabaseCleaner.start
end

After do |_scenario|
  DatabaseCleaner.clean
end
