require "spec_helper"

describe "Odoo 8.0 Docker image - Application" do
  before(:all) do
    set :os, family: :debian
    set :backend, :docker
    set :docker_image, image
  end

  describe user('odoo') do
    it { should exist }
  end

  describe file('/etc/odoo/server.cfg') do
    it { should exist }
  end

  describe file('/opt/nh/venv/bin/openerp-server') do
    it { should exist }
    it { should be_executable }
  end

  describe file('/opt/nh/venv/bin/odoo.py') do
    it { should exist }
    it { should be_executable }
  end

  describe virtualenv('/opt/nh/venv') do
    its(:pip_freeze) { should include('psycopg2' => '2.7.1') }
  end
end
