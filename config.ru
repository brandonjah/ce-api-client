require './app'
use Rack::Logger
use Rack::PostBodyContentTypeParser
run CeApiClient