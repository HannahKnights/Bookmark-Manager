require 'spec_helper'
require_relative 'helpers/session'

include SessionHelpers


feature "User browses the list of links" do

  before(:each) do
      User.create(:email => 'test@test.com',
                  :password => 'test',
                  :password_confirmation => 'test')
    end
  
  before(:each) {
    Link.create(:url => "http://www.makersacademy.com",
                :title => "Makers Academy", 
                :tags => [Tag.first_or_create(:text => 'education')])
    Link.create(:url => "http://www.google.com", 
                :title => "Google", 
                :tags => [Tag.first_or_create(:text => 'search')])
    Link.create(:url => "http://www.bing.com", 
                :title => "Bing", 
                :tags => [Tag.first_or_create(:text => 'search')])
    Link.create(:url => "http://www.code.org", 
                :title => "Code.org", 
                :tags => [Tag.first_or_create(:text => 'education')])
  }

  scenario "when opening the home page" do
    visit '/'
    expect(page).to have_content("Makers Academy")
  end

  scenario "filtered by a tag" do
    visit '/tags/search'
    expect(page).not_to have_content("Makers Academy")
    expect(page).not_to have_content("Code.org")
    expect(page).to have_content("Google")
    expect(page).to have_content("Bing")
  end

end

feature "User adds a new link" do

  scenario "when browsing the homepage" do
    expect(Link.count).to eq(0)
    visit '/'
    add_link("http://www.makersacademy.com/", "Makers Academy")
    expect(Link.count).to eq(1)
    link = Link.first
    expect(link.url).to eq("http://www.makersacademy.com/")
    expect(link.title).to eq("Makers Academy")
  end

  scenario "with a few tags" do
    visit '/'
    add_link("http://makersacademy.com/",
              "Makers Academy",
              ['education', 'ruby'])
    link = Link.first
    expect(link.tags.map(&:text)).to include("education")
    expect(link.tags.map(&:text)).to include("ruby")
  end

  xscenario "without a url" do
    visit '/'
    add_link(nil,
            "Makers Academy", 
            ['educaiton'])
    expect(page).to have_content("The URL and Title fields must be filled in")
  end

end










