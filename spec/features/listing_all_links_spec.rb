require 'spec_helper'
require_relative 'helpers/session'

include SessionHelpers


feature "User browses the list of links" do

  scenario "when signed in" do
    sign_up
    sign_in('test@test.com', '123test')
    visit '/'
    expect(page).to have_content("Welcome, Test")
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
    sign_in('test@test.com', '123test')
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
    sign_in('test@test.com', '123test')
    add_link("http://makersacademy.com/",
              "Makers Academy",
              ['education', 'ruby'])
    expect(page).to have_content("Makers Academy education ruby 0 Test")
  end

  scenario "which displays user, tags and description" do
    sign_up
    sign_in('test@test.com', '123test')
    add_link_with_description("http://makersacademy.com/",
                              "Makers Academy",
                              "Excellent code school",
                              ['education', 'ruby'])
    expect(page).to have_content("Makers Academy Excellent code school education ruby 0 Test")
  end

  scenario "which displays tags which are clickable" do
    sign_up
    sign_in('test@test.com', '123test')
    add_link_with_description("http://makersacademy.com/",
                              "Makers Academy",
                              "Excellent code school",
                              ['education', 'ruby'])
    add_link_with_description("http://wikipedia.com/",
            "Wikipedia",
            "Online Encyclopedia",
            ['education', 'encyclopedia'])
    expect(page).to have_content("Current links: Makers Academy Excellent code school education ruby 0 Test
                                  Wikipedia Online Encyclopedia education encyclopedia 0 Test")
    page.first(:link, "education").click
    expect(page). to have_content("Links tagged with 'education'
                                  Makers Academy Excellent code school education ruby 0 Test
                                  Wikipedia Online Encyclopedia education encyclopedia 0 Test")
  end

end

feature "User adds a new link" do

  scenario "when browsing the homepage" do
    sign_up
    sign_in('test@test.com', '123test')
    expect(Link.count).to eq(0)
    visit '/'
    add_link("http://www.makersacademy.com/", "Makers Academy", ["tag"])
    expect(Link.count).to eq(1)
    link = Link.first
    expect(link.url).to eq("http://www.makersacademy.com/")
    expect(link.title).to eq("Makers Academy")
  end

  scenario "with a few tags" do
    sign_up
    sign_in('test@test.com', '123test')
    visit '/'
    add_link("http://makersacademy.com/",
              "Makers Academy",
              ['education', 'ruby'])
    link = Link.first
    expect(link.tags.map(&:text)).to include("education")
    expect(link.tags.map(&:text)).to include("ruby")
  end

  scenario "without filling in all the required fields" do
    sign_up
    sign_in('test@test.com', '123test')
    visit '/'
    add_link("www.test.com",
            nil, 
            ['test'])
    expect(page).to have_content("Links must have a url, title and tag!")
    expect(page).not_to have_content("Available tags: test")
  end

  xscenario "with a valid url" do
    sign_up
    sign_in('test@test.com', '123test')
    visit '/'
    add_link("invalid_url",
            "Makers Academy", 
            ['educaiton'])
    expect(page).to have_content("Links must have a url, title and tag!")
  end

end










