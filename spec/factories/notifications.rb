FactoryBot.define do
  factory :notification do
    user { nil }
    alert { nil }
    channel { "MyString" }
    content { "MyText" }
    status { "MyString" }
    read_at { "2025-05-25 18:58:09" }
  end
end
