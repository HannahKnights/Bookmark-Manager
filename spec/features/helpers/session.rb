module SessionHelpers

  def sign_in(email, password)
    visit '/sessions/new'
    fill_in 'email', :with => email
    fill_in 'password', :with => password
    click_button 'Sign in'
  end

  def sign_up(username= "Test", email= "test@test.com", password= "123test", password_confirmation= "123test")
    visit '/users/new'
    fill_in :username, :with => username
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

  def add_link(url, title, tags = [])
    within('#new_link') do
      fill_in 'url', :with => url
      fill_in 'title', :with => title
      fill_in 'tags', :with => tags.join(' ')
      click_button 'Add link'
    end
  end

  def add_link_with_description(url, title, description, tags = [])
    within('#new_link') do
      fill_in 'url', :with => url
      fill_in 'title', :with => title
      fill_in 'description', :with => description  
      fill_in 'tags', :with => tags.join(' ')
      click_button 'Add link'
    end
  end  

end
