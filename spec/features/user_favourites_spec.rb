require 'spec_helper'
require_relative 'helpers/session'

include SessionHelpers


feature "Favourite links" do 

  scenario "are created by the user" do
    sign_up
    sign_in('test@test.com', 'test')
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
    sign_in('test@test.com', 'test')
    add_link("http://makersacademy.com",
            "Makers Academy", 
            ['educaiton'])
    visit '/'
    click_button "Add to favourites"
    click_button "Sign out"
    User.create(:email => 'another@another.com',
                :password => 'test',
                :password_confirmation => 'test')
    sign_in('another@another.com', 'test')
    click_button "Add to favourites"
    expect(page).to have_content("Makers Academy 2")
  end



end