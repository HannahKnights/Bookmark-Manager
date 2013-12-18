require 'spec_helper'

feature "User browses the list of links" do
  
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

  def add_link(url, title, tags = [])
    within('#new-link') do
      fill_in 'url', :with => url
      fill_in 'title', :with => title
      fill_in 'tags', :with => tags.join(' ')
      click_button 'Add link'
    end
  end

  feature "User signs up" do

    scenario "when being logged out" do
      lambda { sign_up }.should change(User, :count).by(1)
      # visit '/users/new'
      # puts page.body.inspect
      # expect(page.current_path).to eq ("/users/new")
      expect(page).to have_content("Welcome, hello@example.com")
      expect(User.first.email).to eq("hello@example.com")
    end

    scenario "with a password that doesn't match" do
      lambda { sign_up('a@a.com', 'pass', 'wrong')}.should change(User, :count).by(0)
      expect(current_path).to eq('/users')
      expect(page).to have_content("Password does not match the confirmation")
    end

    def sign_up(email = "hello@example.com",
                password = "oranges",
                password_confirmation = "oranges")
      visit '/users/new'
      fill_in :email, :with => email
      fill_in :password, :with => password
      fill_in :password_confirmation, :with => password_confirmation
      click_button "Sign up"
    end


    scenario "with an email that is already registered" do
      lambda { sign_up }.should change(User, :count).by(1)
      lambda { sign_up }.should change(User, :count).by(0)
      expect(page).to have_content("This email is already taken")
    end


  end


end


