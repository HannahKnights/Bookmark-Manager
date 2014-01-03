def remember_me(email, password, remember_me)
  if remember_me != nil
    session[:remember_me_email], session[:remember_me_password] = email, password
  end
end

get '/sessions/new' do
  erb :"sessions/new"
end

post '/sessions' do
  email, password, remember_me = params[:email], params[:password], params[:remember_me]
  user = User.authenticate(email, password)
  if user
    session[:user_id] = user.id
    remember_me(email, password, remember_me)
    redirect to('/')
  else
    flash.now[:errors] = ["The email or password are incorrect"]
    erb :"sessions/new"
  end
end

delete '/sessions' do
  flash[:notice] = "Goodbye!"
  session[:user_id] = nil
  redirect to '/'
end
