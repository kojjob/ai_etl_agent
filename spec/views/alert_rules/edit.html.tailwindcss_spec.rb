require 'rails_helper'

RSpec.describe "alert_rules/edit", type: :view do
  let(:alert_rule) {
    AlertRule.create!(
      name: "MyString",
      description: "MyText",
      target_entity_type: "MyString",
      condition: "",
      severity: "MyString",
      notification_channels: "",
      is_active: false
    )
  }

  before(:each) do
    assign(:alert_rule, alert_rule)
  end

  it "renders the edit alert_rule form" do
    render

    assert_select "form[action=?][method=?]", alert_rule_path(alert_rule), "post" do

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
