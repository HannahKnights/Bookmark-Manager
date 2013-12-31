post '/favourites' do
  link_id, user_id = params['favourite_link'], session[:user_id]
  if LinkUser.first(:user_id => user_id, :link_id => link_id) == nil
    LinkUser.create(:user_id => user_id, :link_id => link_id)
  else
  end
  redirect to '/'
end