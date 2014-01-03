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

    scenario "with a password that doesn't match" do
      visit '/users/new'
      fill_in :email, :with => "wrong_format"
      fill_in :password, :with => '123test'
      fill_in :password_confirmation, :with => '123teest'
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

    scenario "with correct credentials" do
      visit '/'
      expect(page).not_to have_content("Welcome, Test")
      sign_up
      expect(page).to have_content("Welcome, Test")
    end

    scenario "with incorrect credentials they receive an error" do
      sign_up
      click_button "Sign out"
      visit 'sessions/new'
      sign_in('test@test.com', 'wrong')
      expect(page).to have_content("The email or password are incorrect")
    end

    scenario "whilst signed in" do
      sign_up
      sign_in('test@test.com', '123test')
      click_link "Sign in"
      expect(page).to have_content("Hey Test! Do you realise you are already signed in?")
    end

    scenario "after clicking the 'remember me' on a previous visit" do
      sign_up
      click_button "Sign out"
      visit '/sessions/new'
      fill_in 'email', :with => 'test@test.com'
      fill_in 'password', :with => '123test'
      check('remember_me')
      click_button 'Sign in'      
      expect(page).to have_content("Welcome, Test")
      click_button "Sign out"
      click_link "Sign in"
      expect(page).to have_field('email', :with => 'test@test.com')
      expect(page).to have_field('password', :with => '123test')
    end

  end

  feature "User signs out" do

    scenario 'while being signed in' do
      sign_up
      sign_in('test@test.com', '123test')
      click_button "Sign out"
      expect(page).to have_content("Goodbye!")
      expect(page).not_to have_content("Welcome, test@test.com")
    end

  end
