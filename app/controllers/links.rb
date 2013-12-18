post '/bookmarks' do
  url = params["url"]
  title = params["title"]
  tags = params["tags"].split(" ").map do |tag| 
    Tag.first_or_create(:text => tag)
  end
  Link.create(:title => title,
              :url => url,
              :tags => tags)
  redirect '/'
end