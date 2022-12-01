FactoryBot.define do
  factory :project do
    title { "MyString" }
    description { "MyText" }
    type { "" }
    location { "MyString" }
    thumbnail { "MyString" }
    user { nil }
  end
end
