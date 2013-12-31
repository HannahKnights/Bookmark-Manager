require 'spec_helper'
require_relative 'helpers/session'

include SessionHelpers


feature "Favourite links" do 

  scenario "Are created by the user" do
    sign_up
    sign_in('test@test.com', 'test')
    Link.create(:url => "http://www.makersacademy.com",
                :title => "Makers Academy", 
                :tags => [Tag.first_or_create(:text => 'education')])
    visit '/'
    click_button "Add to favourites"
    click_link "My Favourites"
    expect(page).to have_content("Makers Academy")
  end

  scenario "Can be favourited by many users" do
    sign_up
    sign_in('test@test.com', 'test')
    Link.create(:url => "http://www.makersacademy.com",
                :title => "Makers Academy", 
                :tags => [Tag.first_or_create(:text => 'education')])
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