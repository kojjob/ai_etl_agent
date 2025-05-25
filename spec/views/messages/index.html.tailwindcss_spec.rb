require 'rails_helper'

RSpec.describe "messages/index", type: :view do
  before(:each) do
    assign(:messages, [
      Message.create!(
        session_id: "Session",
        role: "Role",
        content: "MyText",
        data_attachment_path: "Data Attachment Path",
        user: nil
      ),
      Message.create!(
        session_id: "Session",
        role: "Role",
        content: "MyText",
        data_attachment_path: "Data Attachment Path",
        user: nil
      )
    ])
  end

  it "renders a list of messages" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Session".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Role".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Data Attachment Path".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
