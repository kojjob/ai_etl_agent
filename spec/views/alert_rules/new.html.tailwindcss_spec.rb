require 'rails_helper'

RSpec.describe "alert_rules/new", type: :view do
  before(:each) do
    assign(:alert_rule, AlertRule.new(
      name: "MyString",
      description: "MyText",
      target_entity_type: "MyString",
      condition: "",
      severity: "MyString",
      notification_channels: "",
      is_active: false
    ))
  end

  it "renders new alert_rule form" do
    render

    assert_select "form[action=?][method=?]", alert_rules_path, "post" do
      assert_select "input[name=?]", "alert_rule[name]"

      assert_select "textarea[name=?]", "alert_rule[description]"

      assert_select "input[name=?]", "alert_rule[target_entity_type]"

      assert_select "input[name=?]", "alert_rule[condition]"

      assert_select "input[name=?]", "alert_rule[severity]"

      assert_select "input[name=?]", "alert_rule[notification_channels]"

      assert_select "input[name=?]", "alert_rule[is_active]"
    end
  end
end
