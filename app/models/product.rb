class Product < ApplicationRecord
  validates :slug, presence: true, uniqueness: true
  validates :price_net, presence: true, numericality: { greater_than: 0.0 }
  validates :price_gross, presence: true, numericality: { greater_than: 0.0 }
end
