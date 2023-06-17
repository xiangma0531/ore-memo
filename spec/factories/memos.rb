FactoryBot.define do
  factory :memo do
    title { Faker::Book.title }
    content { Faker::Lorem.sentence }
    association :user

    after(:build) do |memo|
      memo.image.attach(io: File.open('public/images/dammy.png'), filename: 'dammy.png')
    end
  end
end
