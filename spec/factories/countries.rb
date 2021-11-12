FactoryBot.define do
  sequence :title do |n|
    "title #{n}"
  end

  factory :country do
    title
  end
end
