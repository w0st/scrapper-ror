require 'rails_helper'

RSpec.describe Product, type: :model do
  before { build(:product) }

  it { should validate_presence_of(:slug) }
  it { should validate_uniqueness_of(:slug) }
  it { should validate_presence_of(:price_net) }
  it { should validate_numericality_of(:price_net).is_greater_than(0.0) }
  it { should validate_presence_of(:price_gross) }
  it { should validate_numericality_of(:price_gross).is_greater_than(0.0) }
end
