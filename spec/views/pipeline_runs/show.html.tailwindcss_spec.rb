require 'rails_helper'

RSpec.describe "pipeline_runs/show", type: :view do
  before(:each) do
    assign(:pipeline_run, PipelineRun.create!(
      pipeline: nil,
      pipeline_version_at_run: 2,
      status: "Status",
      triggered_by_type: "Triggered By Type",
      triggered_by_user: nil,
      duration_ms: "",
      parameters: "",
      summary_metrics: ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Status/)
    expect(rendered).to match(/Triggered By Type/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
