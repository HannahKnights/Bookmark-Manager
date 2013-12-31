post '/bookmarks' do
  url = params["url"]
  title = params["title"]
  description = params["description"]
  tags = params["tags"].split(" ").map do |tag| 
    Tag.first_or_create(:text => tag)
  end
  if Link.create(:title => title,
                :url => url,
                :description => description,
                :tags => tags)
  redirect to('/')
  puts "Saved!"
  else
    flash.now[:errors] = @user.errors.full_messages
    puts "BOO"
  end
end