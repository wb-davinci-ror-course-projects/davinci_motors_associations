class User < ActiveRecord::Base
  has_secure_password
  validate :password, presence: true
end
