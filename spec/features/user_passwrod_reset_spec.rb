require 'spec_helper'
require_relative 'helpers/session'

include SessionHelpers


feature "User forgets their password" do

  before(:each) do
    User.create(:email => 'test@test.com',
                :password => '123test',
                :password_confirmation => '123test')
  end

  scenario "which generates a password token" do
    visit'/sessions/new'
    expect(page).to have_content("Forgotten password?")
    forgotten_password('test@test.com')
    user = User.first
    User.stub(:send_email)
    expect(user.password_token).not_to be(nil)
  end

  scenario "and doesn't have a password token before requesting one" do
    sign_in('test@test.com', '123test')
    user = User.first
    expect(user.password_token).to be(nil)
  end

  xscenario "receives an email" do
    user = User.first
    visit '/sessions/new'
    user.should_receive(:send_email)
    user.stub(:first => user)
    forgotten_password('test@test.com')
  end

end

  feature "User can reset their password" do

  before(:each) do
    User.create(:email => 'test@test.com',
                :password => '123test',
                :password_confirmation => '123test',
                :password_token => 'fake',
                :password_token_timestamp => Time.new(2002, 10, 31, 0, 0, 0) 
                )
  end

  scenario "is redirected to a new password page from the email" do
    # forgotten_password('test@test.com')
    user = User.first
    URL = user.url_safe_token
    visit '/users/reset_password/'+ URL
    expect(page).to have_content("New Password")
  end

  scenario "won't update the password if the token timestamp is older than an hour" do
    user = User.first
    # puts user
    # puts user.password_token
    # User.first.stub('fake')
    visit '/users/reset_password/'+'fake'
    fill_in :password, :with => '123test'
    fill_in :password_confirmation, :with => '123test'
    click_button "Submit"
    # user = User.first(:email => 'test@test.com')
    # puts user
    expect(page).to have_content("Sorry your password token was issued too long ago")
  end

  xscenario "after which the password token is reset to nil" do
    User.create(:email => 'another@test.com',
                :password => '123test',
                :password_confirmation => '123test',
                :password_token => 'fake',
                :password_token_timestamp => Time.new(2002, 10, 31, 0, 0, 0) 
                )
    user = User.first(:email => 'another@test.com')
    expect(user.password_token).not_to be(nil)
    visit '/users/reset_password/'+'fake'
    fill_in :password, :with => '123test'
    fill_in :password_confirmation, :with => '123test'
    click_button "Submit"
    visit ('../')
    expect(user.password_token).to eq(nil)
  end


end
