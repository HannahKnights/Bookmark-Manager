post '/favourites' do
  link_id, user_id = params['favourite_link'], session[:user_id]
  link_user_id = Link.first(:id => link_id).user_id 
  if LinkUser.first(:user_id => user_id,
                   :link_id => link_id,
                   :link_user_id => link_user_id) == nil
    LinkUser.create(:user_id => user_id,
                    :link_id => link_id,
                    :link_user_id => link_user_id)
  else
    flash[:notice] = "You have favourited this link before!"
  end
  redirect to '/'
end