FactoryBot.define do
  factory :audit_log do
    user { nil }
    action { "MyString" }
    entity { nil }
    old_value { "" }
    new_value { "" }
    ip_address { "MyString" }
  end
end
