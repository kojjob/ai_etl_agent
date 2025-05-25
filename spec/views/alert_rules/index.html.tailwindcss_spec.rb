require 'rails_helper'

RSpec.describe "alert_rules/index", type: :view do
  before(:each) do
    assign(:alert_rules, [
      AlertRule.create!(
        name: "Name",
        description: "MyText",
        target_entity_type: "Target Entity Type",
        condition: "",
        severity: "Severity",
        notification_channels: "",
        is_active: false
      ),
      AlertRule.create!(
        name: "Name",
        description: "MyText",
        target_entity_type: "Target Entity Type",
        condition: "",
        severity: "Severity",
        notification_channels: "",
        is_active: false
      )
    ])
  end

  it "renders a list of alert_rules" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Target Entity Type".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Severity".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
