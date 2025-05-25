require 'rails_helper'

RSpec.describe "pipeline_steps/index", type: :view do
  before(:each) do
    assign(:pipeline_steps, [
      PipelineStep.create!(
        pipeline: nil,
        name: "Name",
        description: "MyText",
        step_type: "Step Type",
        sequence_order: 2,
        configuration: "",
        source_connection: nil,
        target_connection: nil,
        expected_input_schema: "",
        expected_output_schema: "",
        ui_position: ""
      ),
      PipelineStep.create!(
        pipeline: nil,
        name: "Name",
        description: "MyText",
        step_type: "Step Type",
        sequence_order: 2,
        configuration: "",
        source_connection: nil,
        target_connection: nil,
        expected_input_schema: "",
        expected_output_schema: "",
        ui_position: ""
      )
    ])
  end

  it "renders a list of pipeline_steps" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Step Type".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
  end
end
