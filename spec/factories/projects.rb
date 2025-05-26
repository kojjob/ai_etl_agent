FactoryBot.define do
  factory :project do
    name { "MyString" }
    description { "MyText" }
    created_by_user { nil }
    status { "MyString" }
    started_at { "2025-05-25 15:31:23" }
    due_at { "2025-05-25 15:31:23" }
    tags { "" }
  end
end
