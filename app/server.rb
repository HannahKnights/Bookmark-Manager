require 'sinatra'
require 'data_mapper'
require 'rack-flash'
require 'sinatra/partial'
require 'rest_client'
require 'dm-validations'


require_relative 'helpers/application'
require_relative 'models/link'
require_relative 'models/tag'
require_relative 'models/user'
require_relative 'controllers/sessions'
require_relative 'controllers/users'
require_relative 'controllers/tags'
require_relative 'controllers/links'
require_relative 'controllers/application'
require_relative 'controllers/password_reset'
require_relative 'controllers/favourites'
require_relative 'data_mapper_setup'


enable :sessions
set :session_secret, 'link_up_session_secret'
set :expire_after, 2628000
use Rack::Flash
set :partial_template_engine, :erb

# set :root, File.dirname(__FILE__)

