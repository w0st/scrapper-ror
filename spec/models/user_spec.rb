require 'rails_helper'

RSpec.describe User, type: :model do
  before { build(:user) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should define_enum_for(:status).with(normal: 0, premium: 1, premium_plus: 2) }
end
