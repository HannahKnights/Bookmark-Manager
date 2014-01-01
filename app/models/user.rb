require 'bcrypt'
require 'rest_client'
require 'cgi'

class User

  attr_reader :password
  attr_accessor :password_confirmation

  include DataMapper::Resource

  # has n, :tags, :through => Resource
  has n, :links, :through => Resource

  property :id, Serial
  property :email, String, :unique => true, :message => "This email is already taken"
  property :username, String
  property :password_digest, Text
  property :password_token, Text
  property :password_token_timestamp, Time

  validates_confirmation_of :password

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
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
  mailgun_api_key = ENV['MAILGUN_API_KEY']
  mailgun_api_url = "https://api:#{mailgun_api_key}@api.mailgun.net/v2/app20531917.mailgun.org"
  
  RestClient.post mailgun_api_url+"/messages",
    :from => "noreply@yourbookmarkmanager.co.uk",
    :to => "#{self.email}",
    :subject => "Password Reset",
    :html => "To reset your bookmark manager password follow this <a href='https://afternoon-falls-1759.herokuapp.com/users/reset_password/#{url_safe_token}'>link</a>."
  end

  def time_check(password_token)
    self.password_token_timestamp.between?(Time.now - 60*60, Time.now)
  end

end