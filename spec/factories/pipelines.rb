FactoryBot.define do
  factory :pipeline do
    name { "MyString" }
    description { "MyText" }
    created_by_user { nil }
    project { nil }
    version { 1 }
    status { "MyString" }
    tags { "" }
    ai_assisted_design_details { "" }
  end
end
