require 'rails_helper'

RSpec.describe "notifications/new", type: :view do
  before(:each) do
    assign(:notification, Notification.new(
      user: nil,
      alert: nil,
      channel: "MyString",
      content: "MyText",
      status: "MyString"
    ))
  end

  it "renders new notification form" do
    render

    assert_select "form[action=?][method=?]", notifications_path, "post" do
      assert_select "input[name=?]", "notification[user_id]"

      assert_select "input[name=?]", "notification[alert_id]"

      assert_select "input[name=?]", "notification[channel]"

      assert_select "textarea[name=?]", "notification[content]"

      assert_select "input[name=?]", "notification[status]"
    end
  end
end
