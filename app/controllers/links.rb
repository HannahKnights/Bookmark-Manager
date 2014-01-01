def create_tag(tags)
tag_string = tags.split(/[\s\W]/).map do |tag|
  Tag.first_or_create(:text => tag)
  end
end


post '/bookmarks' do
  url = params["url"]
  title = params["title"]
  description = params["description"]
  user_id = session[:user_id]
  tags = create_tag(params["tags"])
  if Link.create(:user_id => user_id,
                :title => title,
                :url => url,
                :description => description,
                :tags => tags)
  redirect to('/')
  else
    flash.now[:errors] = @user.errors.full_messages
  end


end