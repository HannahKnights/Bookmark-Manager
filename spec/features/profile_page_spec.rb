require 'spec_helper'

feature "User's profile page" do 

  scenario "displays the tags a user has submitted" do
    sign_up
    sign_in('test@test.com', '123test')
    add_link("http://makersacademy.com",
            "Makers Academy",
            ['education'])
    click_link "My Favourites"
    expect(page).to have_content("My Tags: education")
  end

  scenario "displays the links that they've submitted" do
    sign_up
    sign_in('test@test.com', '123test')
    add_link("http://makersacademy.com",
            "Makers Academy",
            ['education'])
    add_link("http://test.com",
            "Test",
            ['test'])
    click_link "My Favourites"
    expect(page).to have_content("My Links: Makers Academy")
  end
  
end