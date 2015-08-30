require 'open-uri'
require 'nokogiri'

require 'capybara'

include Capybara::DSL

Capybara.configure do |config|
  config.run_server = false
  config.default_driver = :selenium
  config.app_host = 'https://www.wordpress.com' 
end

class WelcomeController < ApplicationController
	include Capybara::DSL
	@largeposts=[]
	@that=nil
	@thatval=nil
	@uniqueposts={}
  def index

	end

end

