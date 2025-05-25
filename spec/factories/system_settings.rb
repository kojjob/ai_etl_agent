FactoryBot.define do
  factory :system_setting do
    setting_key { "MyString" }
    setting_value { "" }
    description { "MyText" }
    is_sensitive { false }
  end
end
