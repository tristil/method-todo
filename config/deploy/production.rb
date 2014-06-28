server "#{ENV['DEPLOY_USER']}@#{ENV['DEPLOY_SERVER']}", roles: [:app, :web, :db]
