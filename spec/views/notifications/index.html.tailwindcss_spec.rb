require 'rails_helper'

RSpec.describe "notifications/index", type: :view do
  before(:each) do
    assign(:notifications, [
      Notification.create!(
        user: nil,
        alert: nil,
        channel: "Channel",
        content: "MyText",
        status: "Status"
      ),
      Notification.create!(
        user: nil,
        alert: nil,
        channel: "Channel",
        content: "MyText",
        status: "Status"
      )
    ])
  end

  it "renders a list of notifications" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Channel".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Status".to_s), count: 2
  end
end
