post '/favourites' do
  link_id = params['favourite_link']
  link_user_id = Link.first(:id => link_id).user_id 
  user_id = session[:user_id]
  if LinkUser.first(:user_id => user_id,
                   :link_id => link_id,
                   :link_user_id => link_user_id) == nil
    LinkUser.create(:user_id => user_id,
                   :link_id => link_id,
                   :link_user_id => link_user_id)
  else
  end
  redirect to '/'
end