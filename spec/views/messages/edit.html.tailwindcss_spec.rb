require 'rails_helper'

RSpec.describe "messages/edit", type: :view do
  let(:message) {
    Message.create!(
      session_id: "MyString",
      role: "MyString",
      content: "MyText",
      data_attachment_path: "MyString",
      user: nil
    )
  }

  before(:each) do
    assign(:message, message)
  end

  it "renders the edit message form" do
    render

    assert_select "form[action=?][method=?]", message_path(message), "post" do
      assert_select "input[name=?]", "message[session_id]"

      assert_select "input[name=?]", "message[role]"

      assert_select "textarea[name=?]", "message[content]"

      assert_select "input[name=?]", "message[data_attachment_path]"

      assert_select "input[name=?]", "message[user_id]"
    end
  end
end
