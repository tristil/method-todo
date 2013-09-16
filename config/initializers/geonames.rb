# Setup GeoNames connection for location lookups
geonames_username = ENV["RAILS_GEONAME_USERNAME"]
if geonames_username != 'PUTYOURS'
  Timezone::Configure.begin do |c|
    c.username = geonames_username
  end
  MethodTodo::Application.config.perform_geoname_lookups = true
else
  MethodTodo::Application.config.perform_geoname_lookups = false
  Rails.logger.warn "WARNING  You must change the geonames username value in \
config/settings.yml if you want to use the automate timezone lookup feature"
end

