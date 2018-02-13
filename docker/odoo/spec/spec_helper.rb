require "serverspec"
require "serverspec_extended_types"
require "docker"

def image
  version = ENV['ODOO_BRANCH']
  "odoo-rspec:#{version}"
end
