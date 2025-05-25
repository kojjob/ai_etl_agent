require 'rails_helper'

RSpec.describe "pipeline_runs/edit", type: :view do
  let(:pipeline_run) {
    PipelineRun.create!(
      pipeline: nil,
      pipeline_version_at_run: 1,
      status: "MyString",
      triggered_by_type: "MyString",
      triggered_by_user: nil,
      duration_ms: "",
      parameters: "",
      summary_metrics: ""
    )
  }

  before(:each) do
    assign(:pipeline_run, pipeline_run)
  end

  it "renders the edit pipeline_run form" do
    render

    assert_select "form[action=?][method=?]", pipeline_run_path(pipeline_run), "post" do

      assert_select "input[name=?]", "pipeline_run[pipeline_id]"

      assert_select "input[name=?]", "pipeline_run[pipeline_version_at_run]"

      assert_select "input[name=?]", "pipeline_run[status]"

      assert_select "input[name=?]", "pipeline_run[triggered_by_type]"

      assert_select "input[name=?]", "pipeline_run[triggered_by_user_id]"

      assert_select "input[name=?]", "pipeline_run[duration_ms]"

      assert_select "input[name=?]", "pipeline_run[parameters]"

      assert_select "input[name=?]", "pipeline_run[summary_metrics]"
    end
  end
end
