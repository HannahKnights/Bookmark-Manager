require 'spec_helper'
require_relative 'helpers/session'

include SessionHelpers


feature "User browses the list of links" do

  before(:each) do
      User.create(:email => 'test@test.com',
                  :password => 'test',
                  :password_confirmation => 'test')
    end

  scenario "when signed in" do
    sign_in('test@test.com', 'test')
    visit '/'
    expect(page).to have_content("Welcome, test@test.com")
    fill_in :url, :with => "http://makersacademy.com"
    fill_in :title, :with => "Makers Academy"
    fill_in :description, :with => "Code School"
    fill_in :tags, :with => "code, ruby"
    click_button "Add link"
    expect(page).to have_content("Makers Academy")
  end

  scenario "when signed out" do
    visit '/'
    expect(page).not_to have_content("Add Link")
  end

  scenario "filtered by a tag" do
    sign_up
    sign_in('test@test.com', 'test')
    add_link("http://makersacademy.com/",
              "Makers Academy",
              ['education', 'ruby'])
    add_link("http://test.co.uk",
              "Test",
              ['test'])
    visit '/tags/test'
    expect(page).not_to have_content("Makers Academy")
    expect(page).to have_content("Test")
  end

  scenario "which displays the user who submitted it" do
    sign_up
    sign_in('test@test.com', 'test')
    add_link("http://makersacademy.com/",
              "Makers Academy",
              ['education', 'ruby'])
    expect(page).to have_content("Makers Academy 0 test@test.com")
  end

end

feature "User adds a new link" do

  scenario "when browsing the homepage" do
    sign_up
    sign_in('test@test.com', 'test')
    expect(Link.count).to eq(0)
    visit '/'
    add_link("http://www.makersacademy.com/", "Makers Academy")
    expect(Link.count).to eq(1)
    link = Link.first
    expect(link.url).to eq("http://www.makersacademy.com/")
    expect(link.title).to eq("Makers Academy")
  end

  scenario "with a few tags" do
    sign_up
    sign_in('test@test.com', 'test')
    visit '/'
    add_link("http://makersacademy.com/",
              "Makers Academy",
              ['education', 'ruby'])
    link = Link.first
    expect(link.tags.map(&:text)).to include("education")
    expect(link.tags.map(&:text)).to include("ruby")
  end

  xscenario "without a url" do
    sign_up
    sign_in('test@test.com', 'test')
    visit '/'
    add_link(nil,
            "Makers Academy", 
            ['educaiton'])
    expect(page).to have_content("The URL and Title fields must be filled in")
  end

end










