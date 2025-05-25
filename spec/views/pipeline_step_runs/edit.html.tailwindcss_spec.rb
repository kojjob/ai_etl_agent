require 'rails_helper'

RSpec.describe "pipeline_step_runs/edit", type: :view do
  let(:pipeline_step_run) {
    PipelineStepRun.create!(
      pipeline_run: nil,
      pipeline_step: nil,
      status: "MyString",
      duration_ms: "",
      metrics: "",
      logs_summary: "MyText",
      input_data_preview: "",
      output_data_preview: ""
    )
  }

  before(:each) do
    assign(:pipeline_step_run, pipeline_step_run)
  end

  it "renders the edit pipeline_step_run form" do
    render

    assert_select "form[action=?][method=?]", pipeline_step_run_path(pipeline_step_run), "post" do
      assert_select "input[name=?]", "pipeline_step_run[pipeline_run_id]"

      assert_select "input[name=?]", "pipeline_step_run[pipeline_step_id]"

      assert_select "input[name=?]", "pipeline_step_run[status]"

      assert_select "input[name=?]", "pipeline_step_run[duration_ms]"

      assert_select "input[name=?]", "pipeline_step_run[metrics]"

      assert_select "textarea[name=?]", "pipeline_step_run[logs_summary]"

      assert_select "input[name=?]", "pipeline_step_run[input_data_preview]"

      assert_select "input[name=?]", "pipeline_step_run[output_data_preview]"
    end
  end
end
