require 'rails_helper'

RSpec.describe "audit_logs/show", type: :view do
  before(:each) do
    assign(:audit_log, AuditLog.create!(
      user: nil,
      action: "Action",
      entity: nil,
      old_value: "",
      new_value: "",
      ip_address: "Ip Address"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Action/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Ip Address/)
  end
end
