require 'bcrypt'
require 'rest_client'
require 'cgi'

class User

  attr_reader :password
  attr_accessor :password_confirmation

  include DataMapper::Resource

  # has n, :tags, :through => Resource
  has n, :links

  property :id, Serial
  property :email, String, :required => true, :unique => true, :format => :email_address
  property :username, String
  property :password_digest, Text, :required => true, :message => "Please enter a valid password"
  property :password_token, Text
  property :password_token_timestamp, Time

  validates_confirmation_of :password

  def password=(password)
    @password = password
    password_check ? self.password_digest = BCrypt::Password.create(password) : self.password_digest = nil
  end

  def password_check
    /(?=.*[0-9])(?=.*[a-zA-Z])[a-zA-Z0-9]{6,12}/.match("#{@password}") != nil 
  end

  def self.authenticate(email, password)
    user = first(:email => email)
    if user && BCrypt::Password.new(user.password_digest) == password
      user
    else
      nil
    end
  end

  def url_safe_token
    CGI.escape(self.password_token)
  end

  def send_email
  # mailgun_api_key = ENV['MAILGUN_API_KEY']
  # mailgun_api_url = "https://api:#{mailgun_api_key}@api.mailgun.net/v2/app20531917.mailgun.org"
  
  # RestClient.post mailgun_api_url+"/messages",
  #   :from => "noreply@yourbookmarkmanager.co.uk",
  #   :to => "#{self.email}",
  #   :subject => "Password Reset",
  #   :html => "To reset your bookmark manager password follow this <a href='https://afternoon-falls-1759.herokuapp.com/users/reset_password/#{url_safe_token}'>link</a>."
  end

  def send_email_welcome
  # mailgun_api_key = ENV['MAILGUN_API_KEY']
  # mailgun_api_url = "https://api:#{mailgun_api_key}@api.mailgun.net/v2/app20531917.mailgun.org"
  
  # RestClient.post mailgun_api_url+"/messages",
  #   :from => "noreply@yourbookmarkmanager.co.uk",
  #   :to => "#{self.email}",
  #   :subject => "Welcome to link-up",
  #   :html => "Welcome to Link-up #{self.username} follow this <a href='https://afternoon-falls-1759.herokuapp.com'>link</a> to get going."
  end

  def time_check(password_token)
    self.password_token_timestamp.between?(Time.now - 60*60, Time.now)
  end

end