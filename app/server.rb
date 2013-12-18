require 'sinatra'
require 'data_mapper'
require 'rack-flash'
require 'sinatra/partial'
require './lib/link'
require './lib/tag'
require './lib/user'
require_relative 'helpers/application'

require_relative 'controllers/sessions'
require_relative 'controllers/users'
require_relative 'controllers/tags'
require_relative 'controllers/links'
require_relative 'controllers/application'

env = ENV["RACK_ENV"] || "development"

DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")
DataMapper.finalize
DataMapper.auto_upgrade!

enable :sessions
set :session_secret, 'super secret'
use Rack::Flash
set :partial_template_engine, :erb
