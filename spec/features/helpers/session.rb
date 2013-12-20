module SessionHelpers

  def sign_in(email, password)
    visit '/sessions/new'
    fill_in 'email', :with => email
    fill_in 'password', :with => password
    click_button 'Sign in'
  end

  def sign_up(email= "hello@example.com", password= "oranges", password_confirmation= "oranges")
    visit '/users/new'
    fill_in :email, :with => email
    fill_in :password, :with => password
    fill_in :password_confirmation, :with => password_confirmation
    click_button "Sign up"
  end

  def forgotten_password(email)
    visit '/sessions/new'
    click_link('Forgotten password?')
    fill_in :email, :with => email
    click_button "Submit"
  end


end
