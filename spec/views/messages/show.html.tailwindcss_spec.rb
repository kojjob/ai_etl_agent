require 'rails_helper'

RSpec.describe "messages/show", type: :view do
  before(:each) do
    assign(:message, Message.create!(
      session_id: "Session",
      role: "Role",
      content: "MyText",
      data_attachment_path: "Data Attachment Path",
      user: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Session/)
    expect(rendered).to match(/Role/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Data Attachment Path/)
    expect(rendered).to match(//)
  end
end
