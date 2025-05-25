require 'rails_helper'

RSpec.describe "notifications/show", type: :view do
  before(:each) do
    assign(:notification, Notification.create!(
      user: nil,
      alert: nil,
      channel: "Channel",
      content: "MyText",
      status: "Status"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Channel/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Status/)
  end
end
