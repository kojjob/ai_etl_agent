require 'rails_helper'

RSpec.describe "alerts/index", type: :view do
  before(:each) do
    assign(:alerts, [
      Alert.create!(
        pipeline: nil,
        pipeline_run: nil,
        pipeline_step_run: nil,
        rule: nil,
        severity: "Severity",
        message: "MyText",
        status: "Status",
        acknowledged_by_user: nil
      ),
      Alert.create!(
        pipeline: nil,
        pipeline_run: nil,
        pipeline_step_run: nil,
        rule: nil,
        severity: "Severity",
        message: "MyText",
        status: "Status",
        acknowledged_by_user: nil
      )
    ])
  end

  it "renders a list of alerts" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Severity".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Status".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
