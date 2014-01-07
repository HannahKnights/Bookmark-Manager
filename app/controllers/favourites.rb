post '/favourites' do
  link_id, user_id = params['favourite_link'], session[:user_id]
 
  if Favourite.first(:link_user_id => user_id,
                   :link_id => link_id) == nil
    Favourite.create(:link_user_id => user_id,
                    :link_id => link_id)
  else
    flash[:notice] = "You have favourited this link before!"
  end
  redirect to '/'
end