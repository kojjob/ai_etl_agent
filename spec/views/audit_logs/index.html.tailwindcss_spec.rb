require 'rails_helper'

RSpec.describe "audit_logs/index", type: :view do
  before(:each) do
    assign(:audit_logs, [
      AuditLog.create!(
        user: nil,
        action: "Action",
        entity: nil,
        old_value: "",
        new_value: "",
        ip_address: "Ip Address"
      ),
      AuditLog.create!(
        user: nil,
        action: "Action",
        entity: nil,
        old_value: "",
        new_value: "",
        ip_address: "Ip Address"
      )
    ])
  end

  it "renders a list of audit_logs" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Action".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Ip Address".to_s), count: 2
  end
end
