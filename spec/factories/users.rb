FactoryGirl.define do
  factory :user do
    email 'user@domain.com'
    password 'password'
    password_confirmation 'password'
  end
end
