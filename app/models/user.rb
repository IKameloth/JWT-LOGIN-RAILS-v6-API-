class User < ApplicationRecord
  # macro for bcrypt
  has_secure_password
end
