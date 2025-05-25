FactoryBot.define do
  factory :alert_rule do
    name { "MyString" }
    description { "MyText" }
    target_entity_type { "MyString" }
    condition { "" }
    severity { "MyString" }
    notification_channels { "" }
    is_active { false }
  end
end
