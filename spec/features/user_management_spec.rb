require 'spec_helper'
require_relative 'helpers/session'

include SessionHelpers

  feature "User signs up" do

    scenario "creates a user" do
      lambda { sign_up }.should change(User, :count).by(1)
      expect(page).to have_content("Welcome, Test")
      expect(User.first.email).to eq("test@test.com")
    end

    scenario "with an email that is already registered" do
      lambda { sign_up }.should change(User, :count).by(1)
      lambda { sign_up }.should change(User, :count).by(0)
    end

    scenario "with an email that is an incorrect format" do
      visit '/users/new'
      fill_in :email, :with => "wrong_format"
      fill_in :password, :with => '123test'
      fill_in :password_confirmation, :with => '123test'
      click_button "Sign up"
      expect(page).to have_content("Email has an invalid format")
    end

    scenario "whilst signed in" do
      sign_up
      click_link "Sign up"
      expect(page).to have_content("Hey test@test.com! Do you realise you are already signed in?")
    end

    scenario "without an email address" do
      visit '/users/new'
      fill_in :username, :with => 'Test'
      fill_in :password, :with => 'test'
      fill_in :password_confirmation, :with => 'test'
      click_button "Sign up"
      expect(page).to have_content("Email must not be blank")
    end

    scenario "without a password" do
      visit '/users/new'
      fill_in :username, :with => 'Test'
      fill_in :email, :with => 'test@test.com'
      click_button "Sign up"
      expect(page).to have_content("Please enter a valid password")
    end

    scenario "with a password that is in an invalid format" do
      visit '/users/new'
      fill_in :username, :with => 'Test'
      fill_in :email, :with => 'test@test.com'
      fill_in :password, :with => 'test'
      fill_in :password_confirmation, :with => 'test'
      click_button "Sign up"
      expect(page).to have_content("Please enter a valid password")
    end


  end


  feature "User signs in" do

    before(:each) do
      User.create(:email => "test@test.com",
                  :password => '123test',
                  :password_confirmation => '123test')
    end

    scenario "with a password that doesn't match" do
      lambda { sign_up('a@a.com', '123pass', '123wrong')}.should change(User, :count).by(0)
      expect(current_path).to eq('/users')
      expect(page).to have_content("Password does not match the confirmation")
    end

    scenario "with correct credentials" do
      visit '/'
      expect(page).not_to have_content("Welcome, test@test.com")
      sign_in('test@test.com', '123test')
      expect(page).to have_content("Welcome, test@test.com")
    end

    scenario "with incorrect credentials they receive an error" do
      visit 'sessions/new'
      sign_in('test@test.com', 'wrong')
      expect(page).to have_content("The email or password are incorrect")
    end

    scenario "whilst signed in" do
      sign_in('test@test.com', '123test')
      click_link "Sign in"
      expect(page).to have_content("Hey test@test.com! Do you realise you are already signed in?")
    end

  end

  feature "User signs out" do

    before(:each) do
      User.create(:email => 'test@test.com',
                  :password => '123test',
                  :password_confirmation => '123test')
    end

    scenario 'while being signed in' do
      sign_in('test@test.com', '123test')
      click_button "Sign out"
      expect(page).to have_content("Goodbye!")
      expect(page).not_to have_content("Welcome, test@test.com")
    end

  end
