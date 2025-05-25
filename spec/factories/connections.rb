FactoryBot.define do
  factory :connection do
    name { "MyString" }
    description { "MyText" }
    type { "" }
    configuration { "" }
    test_status { "MyString" }
    last_tested_at { "2025-05-25 15:41:01" }
    created_by_user { nil }
  end
end
