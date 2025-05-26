require 'rails_helper'

RSpec.describe "messages/new", type: :view do
  before(:each) do
    assign(:message, Message.new(
      session_id: "MyString",
      role: "MyString",
      content: "MyText",
      data_attachment_path: "MyString",
      user: nil
    ))
  end

  it "renders new message form" do
    render

    assert_select "form[action=?][method=?]", messages_path, "post" do
      assert_select "input[name=?]", "message[session_id]"

      assert_select "input[name=?]", "message[role]"

      assert_select "textarea[name=?]", "message[content]"

      assert_select "input[name=?]", "message[data_attachment_path]"

      assert_select "input[name=?]", "message[user_id]"
    end
  end
end
