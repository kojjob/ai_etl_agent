require 'rails_helper'

RSpec.describe "pipeline_step_runs/show", type: :view do
  before(:each) do
    assign(:pipeline_step_run, PipelineStepRun.create!(
      pipeline_run: nil,
      pipeline_step: nil,
      status: "Status",
      duration_ms: "",
      metrics: "",
      logs_summary: "MyText",
      input_data_preview: "",
      output_data_preview: ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Status/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
