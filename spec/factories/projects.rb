FactoryBot.define do
  factory :project do
    association :user
    sequence(:title) { |idx| "Project_#{idx}" }
    description { 'MyText' }
    project_type { 'external' }
    location { 'My Location' }
    thumbnail { Rack::Test::UploadedFile.new('spec/fixtures/files/thumbnail.jpg') }
  end
end
