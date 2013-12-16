require 'sinatra'
require 'data_mapper'

env = ENV["RACK_ENV"] || "development"
DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

require './lib/link'

DataMapper.finalize
DataMapper.auto_upgrade!


get '/' do
  @links = Link.all
  erb :index
end

post '/bookmarks' do
  Link.create(:title => params["title"],
              :url => params["url"])
  redirect '/'
end
