require "rubygems"
require "bundler"

Bundler.require(:default, ENV["RACK_ENV"].to_sym)
configure do
	enable  :logging
end