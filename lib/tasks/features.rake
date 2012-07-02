namespace :doc do
  desc "runs cucumber features and outputs them to doc/cucumber as html"
  task :features do 
    Dir.glob("features/*.feature").each do |story|
    system(
      "cucumber", 
      "#{story}", 
      "--format",
      "html",
      "-o", 
      "doc/cucumber/#{story.gsub(/features\/(\w*).feature/, '\1.html')}"
    )
    end
  end
end
