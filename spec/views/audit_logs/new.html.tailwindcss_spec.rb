require 'rails_helper'

RSpec.describe "audit_logs/new", type: :view do
  before(:each) do
    assign(:audit_log, AuditLog.new(
      user: nil,
      action: "MyString",
      entity: nil,
      old_value: "",
      new_value: "",
      ip_address: "MyString"
    ))
  end

  it "renders new audit_log form" do
    render

    assert_select "form[action=?][method=?]", audit_logs_path, "post" do
      assert_select "input[name=?]", "audit_log[user_id]"

      assert_select "input[name=?]", "audit_log[action]"

      assert_select "input[name=?]", "audit_log[entity_id]"

      assert_select "input[name=?]", "audit_log[old_value]"

      assert_select "input[name=?]", "audit_log[new_value]"

      assert_select "input[name=?]", "audit_log[ip_address]"
    end
  end
end
