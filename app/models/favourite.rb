class Favourite

  include DataMapper::Resource
  
  belongs_to :link
  
  property :id, Serial
  property :user_id, Serial


end

