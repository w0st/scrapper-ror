class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable

  enum status: [:normal, :premium, :premium_plus]
end
