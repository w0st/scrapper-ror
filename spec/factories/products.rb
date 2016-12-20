FactoryGirl.define do
  factory :product do
    slug 'my_slug'
    title 'Product title'
    price_net 120.12
    price_gross 144.14
  end
end
