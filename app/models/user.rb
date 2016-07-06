class User < ApplicationRecord
  #bcrypt gem method to properly encrypt passwords
  has_secure_password
end
