# Setup GeoNames connection for location lookups
geonames_username = ENV["RAILS_GEONAME_USERNAME"]
if geonames_username != 'PUTYOURS'
  Timezone::Configure.begin do |c|
    c.username = geonames_username
  end
  MethodTodo::Application.config.perform_geoname_lookups = true
else
  MethodTodo::Application.config.perform_geoname_lookups = false
  Rails.logger.warn %s{
WARNING  You must set a RAILS_GEONAME_USERNAME environment variable if you want
to use the automatic timezone lookup feature"
}
end

