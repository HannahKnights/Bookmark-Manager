class Link

  include DataMapper::Resource

  has n, :tags, :through => Resource
  # has 1, :user, :through => Resource 
  
  property :id, Serial
  property :title, String
  property :url, String
  # property :user_id, Serial
  
end
