require 'rails_helper'

RSpec.describe "notifications/edit", type: :view do
  let(:notification) {
    Notification.create!(
      user: nil,
      alert: nil,
      channel: "MyString",
      content: "MyText",
      status: "MyString"
    )
  }

  before(:each) do
    assign(:notification, notification)
  end

  it "renders the edit notification form" do
    render

    assert_select "form[action=?][method=?]", notification_path(notification), "post" do
      assert_select "input[name=?]", "notification[user_id]"

      assert_select "input[name=?]", "notification[alert_id]"

      assert_select "input[name=?]", "notification[channel]"

      assert_select "textarea[name=?]", "notification[content]"

      assert_select "input[name=?]", "notification[status]"
    end
  end
end
