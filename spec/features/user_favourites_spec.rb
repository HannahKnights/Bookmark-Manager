require 'spec_helper'
require_relative 'helpers/session'

include SessionHelpers


feature "Favourite links" do 

  scenario "are created by the user" do
    sign_up
    sign_in('test@test.com', '123test')
    add_link("http://makersacademy.com",
            "Makers Academy",
            ['education'])
    visit '/'
    click_button "Add to favourites"
    click_link "My Favourites"
    expect(page).to have_content("Makers Academy")
  end

  scenario "can be favourited by many users" do
    sign_up
    sign_in('test@test.com', '123test')
    add_link("http://makersacademy.com",
            "Makers Academy", 
            ['educaiton'])
    visit '/'
    click_button "Add to favourites"
    click_button "Sign out"
    User.create(:email => 'another@another.com',
                :password => '123test',
                :password_confirmation => '123test')
    sign_in('another@another.com', '123test')
    click_button "Add to favourites"
    expect(page).to have_content("Makers Academy 2")
  end



end