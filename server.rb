require 'sinatra'
require 'data_mapper'

env = ENV["RACK_ENV"] || "development"
DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

require './lib/link'
require './lib/tag'

DataMapper.finalize
DataMapper.auto_upgrade!


get '/' do
  @links = Link.all
  erb :index
end

post '/bookmarks' do
  tags = params["tags"].split(" ").map do |tag|
    Tag.first_or_create(:text => tag)
  end
  url = params["url"]
  title = params["title"]
  Link.create(:title => title,
              :url => url,
              :tags => tags)
  redirect '/'
end

get '/tags/:text' do
  tag = Tag.first(:text => params[:text])
  @links = tag ? tag.links : []
  erb :index
end



