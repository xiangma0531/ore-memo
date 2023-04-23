FactoryBot.define do
  factory :memo do
    title { 'タイトル' }
    content { Faker::Lorem.sentence }
    association :user

    after(:build) do |memo|
      memo.image.attach(io: File.open('public/images/dummy.png', filename: 'dummy.png'))
    end
  end
end
