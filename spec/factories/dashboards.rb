FactoryBot.define do
  factory :dashboard do
    user { nil }
    name { "MyString" }
    description { "MyText" }
    layout_config { "" }
    is_default { false }
    is_shared { false }
    shared_with_roles { "" }
  end
end
