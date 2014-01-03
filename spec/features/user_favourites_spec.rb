require 'spec_helper'
require_relative 'helpers/session'

include SessionHelpers


feature "Links" do 

  scenario "are given a default 'favourite' when they are created" do
    sign_up
    sign_in('test@test.com', '123test')
    add_link("http://makersacademy.com",
            "Makers Academy",
            ['education'])
    visit '/'
    expect(page).to have_content("1 Makers Academy")
  end

  scenario "can be favourited by many users" do
    sign_up
    sign_in('test@test.com', '123test')
    add_link("http://makersacademy.com",
            "Makers Academy", 
            ['education'])
    visit '/'
    click_button "Sign out"
    User.create(:email => 'another@another.com',
                :password => '123test',
                :password_confirmation => '123test')
    sign_in('another@another.com', '123test')
    click_button "Add to favourites"
    expect(page).to have_content("2 Makers Academy education")
  end

  scenario "appear in a users 'my favourite' when 'favourited'" do
    sign_up
    sign_in('test@test.com', '123test')
    add_link("http://makersacademy.com",
            "Makers Academy", 
            ['education'])
    visit '/'
    click_button "Sign out"
    User.create(:email => 'another@another.com',
                :password => '123test',
                :password_confirmation => '123test')
    sign_in('another@another.com', '123test')
    click_button "Add to favourites"
    click_link "My Favourites"
    expect(page).to have_content("My Favourite Links 2 Makers Academy education")
  end

end