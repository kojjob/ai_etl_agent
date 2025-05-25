require 'rails_helper'

RSpec.describe "audit_logs/edit", type: :view do
  let(:audit_log) {
    AuditLog.create!(
      user: nil,
      action: "MyString",
      entity: nil,
      old_value: "",
      new_value: "",
      ip_address: "MyString"
    )
  }

  before(:each) do
    assign(:audit_log, audit_log)
  end

  it "renders the edit audit_log form" do
    render

    assert_select "form[action=?][method=?]", audit_log_path(audit_log), "post" do
      assert_select "input[name=?]", "audit_log[user_id]"

      assert_select "input[name=?]", "audit_log[action]"

      assert_select "input[name=?]", "audit_log[entity_id]"

      assert_select "input[name=?]", "audit_log[old_value]"

      assert_select "input[name=?]", "audit_log[new_value]"

      assert_select "input[name=?]", "audit_log[ip_address]"
    end
  end
end
