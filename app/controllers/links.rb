def create_tag(tags)
tag_string = tags.split(/[\s\W]/).map do |tag|
  Tag.first_or_create(:text => tag)
  end
end

def destroy_tags(tags)
  tag_string = tags.split(/[\s+\W+]/).map do |tag|
    new_tag = Tag.first(:text => tag)
    new_tag.destroy
  end
end


post '/bookmarks' do
  url, title, description, user_id = params["url"], params["title"], params["description"], session[:user_id]
  tags = create_tag(params["tags"])
  Link.create(:user_id => user_id,
              :title => title,
              :url => url,
              :description => description,
              :tags => tags)
  if Link.first(:user_id => user_id, :title => title, :url => url,)
  else
  destroy_tags(params["tags"])
  flash[:notice] = "Links must have a url, title and tag!"
  end
  redirect to('/')
end