# Setup GeoNames connection for location lookups
credentials_file = MethodTodo::Application.config.root.to_s + "/config/credentials.yml"
credentials = YAML::load_file(credentials_file)
geonames_username = credentials["geonames"]["username"]
Timezone::Configure.begin do |c|
  c.username = geonames_username
end

