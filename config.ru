# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
require 'rack/iframe'
use Rack::Iframe
use Rack::Deflater
run Transitandtrails::Application
