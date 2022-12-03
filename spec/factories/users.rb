FactoryBot.define do
  factory :user do
    first_name { 'John' }
    last_name { 'Doe' }
    sequence(:email) { |idx| "john#{idx}@gmail.com" }
    country { 'USA' }
    password { '123456' }
    password_confirmation { '123456' }
  end
end
