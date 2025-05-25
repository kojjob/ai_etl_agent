require 'rails_helper'

RSpec.describe "alerts/show", type: :view do
  before(:each) do
    assign(:alert, Alert.create!(
      pipeline: nil,
      pipeline_run: nil,
      pipeline_step_run: nil,
      rule: nil,
      severity: "Severity",
      message: "MyText",
      status: "Status",
      acknowledged_by_user: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Severity/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Status/)
    expect(rendered).to match(//)
  end
end
