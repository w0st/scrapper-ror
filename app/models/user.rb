class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable

  enum status: [:normal, :premium, :premium_plus]

  def allowed?(slug)
    return false if slug.nil?
    if normal?
      slug.size < 15
    elsif premium?
      slug.size < 15 || slug.include?('books')
    else
      premium_plus?
    end
  end
end
