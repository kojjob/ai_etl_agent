require 'rails_helper'

RSpec.describe "pipeline_steps/show", type: :view do
  before(:each) do
    assign(:pipeline_step, PipelineStep.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Step Type/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
