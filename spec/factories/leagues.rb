FactoryBot.define do
  sequence :title do |n|
    "title #{n}"
  end

  factory :league do
    title
  end
end
