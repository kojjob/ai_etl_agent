require 'rails_helper'

RSpec.describe "alert_rules/show", type: :view do
  before(:each) do
    assign(:alert_rule, AlertRule.create!(
      name: "Name",
      description: "MyText",
      target_entity_type: "Target Entity Type",
      condition: "",
      severity: "Severity",
      notification_channels: "",
      is_active: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Target Entity Type/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Severity/)
    expect(rendered).to match(//)
    expect(rendered).to match(/false/)
  end
end
