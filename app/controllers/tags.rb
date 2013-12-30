get '/tags/:text' do
  text = params[:text].to_s
  tag = Tag.first(:text => text)
  @links = tag ? tag.links : []
  @tags = Tag.all
  erb :index
end