FactoryBot.define do
  factory :message do
    session_id { "MyString" }
    role { "MyString" }
    content { "MyText" }
    data_attachment_path { "MyString" }
    user { nil }
  end
end
