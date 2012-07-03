# Setup GeoNames connection for location lookups
credentials_file = MethodTodo::Application.config.root.to_s + "/config/credentials.yml"
credentials = YAML::load_file(credentials_file)
geonames_username = credentials["geonames"]["username"]
if geonames_username != 'PUTYOURS'
  Timezone::Configure.begin do |c|
    c.username = geonames_username
  end
  MethodTodo::Application.config.perform_geoname_lookups = true
else
  MethodTodo::Application.config.perform_geoname_lookups = false
  Rails.logger.warn "WARNING  You must change the geonames username value in \
config/credentials.yml if you want to use the automate timezone lookup feature"
end

