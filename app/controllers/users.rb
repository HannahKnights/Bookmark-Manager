get '/users/new' do
  @user = User.new
  erb :"users/new"
end

post '/users' do
  @user = User.new(:email => params["email"],
                    :password => params["password"],
                    :password_confirmation => params["password_confirmation"])
  if @user.save
    session[:user_id] = @user.id
    redirect to('/')
  else
    flash.now[:errors] = @user.errors.full_messages
    erb :"users/new"
  end
end

get '/users/reset_password' do
  erb :"users/reset_password"
end

post '/reset_password' do
  user = User.first(:email => params["email"])
  user.password_token = Array.new(64) {(65 + rand(58)).chr}.join
  user.password_token_timestamp = Time.now
  user.save  
end


#   @user.password_token(params["email"])
#   @user.send_message
#   session[:user_id] = user.id
#   redirect to('/sessions/new')
# end

get '/users/reset_password/:token' do



end




