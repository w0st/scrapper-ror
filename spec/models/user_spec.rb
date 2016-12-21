require 'rails_helper'

RSpec.describe User, type: :model do
  before { build(:user) }
  let(:premium_plus_user) { create(:user, status: :premium_plus) }
  let(:premium_user) { create(:user, status: :premium) }
  let(:normal_user) { create(:user, status: :normal) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should define_enum_for(:status).with(normal: 0, premium: 1, premium_plus: 2) }

  context 'premium_plus user' do
    it { expect(premium_plus_user.allowed?('desk-calendars')).to be true }
    it { expect(premium_plus_user.allowed?('books-hardcover')).to be true }
    it { expect(premium_plus_user.allowed?('compliment-slips')).to be true }
  end

  context 'premium user' do
    it { expect(premium_user.allowed?('desk-calendars')).to be true }
    it { expect(premium_user.allowed?('books-hardcover')).to be true }
    it { expect(premium_user.allowed?('compliment-slips')).to be false }
  end

  context 'normal user' do
    it { expect(normal_user.allowed?('desk-calendars')).to be true }
    it { expect(normal_user.allowed?('books-hardcover')).to be false }
    it { expect(normal_user.allowed?('compliment-slips')).to be false }
  end
end
