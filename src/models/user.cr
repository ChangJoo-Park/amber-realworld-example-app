require "granite_orm/adapter/pg"
require "crypto/bcrypt/password"

class User < Granite::ORM::Base
  include Crypto
  adapter pg
  primary id : Int64
  field email : String
  field username : String
  field profile_image : String
  field bio : String
  field admin : Bool
  field hashed_password : String
  timestamps

  has_many :articles
  has_many :favorites
  has_many :favorite_articles, through: favorites

  validate :email, "is required", -> (user : User) do
    (email = user.email) ? !email.empty? : false
  end

  validate :password, "is too short", -> (user : User) do
    user.password_changed? ? user.valid_password_size? : true
  end

  def password=(password)
    @new_password = password
    @hashed_password = Bcrypt::Password.create(password, cost: 10).to_s
  end

  def password
    (hash = hashed_password) ? Bcrypt::Password.new(hash) : nil
  end

  def password_changed?
    new_password ? true : false
  end

  def valid_password_size?
    (pass = new_password) ? pass.size >= 8 : false
  end

  def authenticate(password : String)
    (bcrypt_pass = self.password) ? bcrypt_pass == password : false
  end

  private getter new_password : String?
end
