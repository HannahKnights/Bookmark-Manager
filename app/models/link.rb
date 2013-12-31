class Link

  include DataMapper::Resource

  has n, :tags, :through => Resource
  has n, :users, :through => Resource
  belongs_to :user
  # has 1, :user, :through => Resource 
  
  property :id, Serial
  property :user_id, Serial
  property :title, String, :required => true
  property :url, String, :required => true
  property :description, Text
  # property :user_id, Serial
  
end
