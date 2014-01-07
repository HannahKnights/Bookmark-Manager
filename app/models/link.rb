class Link

  include DataMapper::Resource

  belongs_to :user
  has n, :tags, :through => Resource
  # has 1, :user, :through => Resource 
  
  property :id, Serial
  property :user_id, Serial
  property :title, String, :required => true
  property :url, String, :required => true
  property :description, Text
  # property :user_id, Serial
  
end
