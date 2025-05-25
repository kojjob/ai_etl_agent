FactoryBot.define do
  factory :dashboard_widget do
    dashboard { nil }
    widget_type { "MyString" }
    title { "MyString" }
    configuration { "" }
    refresh_interval_seconds { 1 }
  end
end
