get '/users/reset_password' do
  erb :"users/reset_password"
end

post '/reset_password' do
  email = params["email"]
  user = User.first(:email => email)
  user.password_token = Array.new(64) {(65 + rand(58)).chr}.join
  user.password_token_timestamp = Time.now
  user.save
  user.send_email
  redirect to'/'
end

get '/users/reset_password/:token' do
  erb :"users/new_password"
end

post '/change_password' do
  password_token = params[:password_token]
  user = User.first(:password_token => password_token)
  if user.time_check(password_token) == true
    user.update(:password => params["password"],
              :password_confirmation => params["password_confirmation"])
    user.save
    session[:user_id] = user.id
  else
    flash[:notice] = "Sorry your password token was issued too long ago. Please follow the password reset process again"
  end
  user.update(:password_token => nil,
              :password_token_timestamp => nil)
  redirect to('../')
end




