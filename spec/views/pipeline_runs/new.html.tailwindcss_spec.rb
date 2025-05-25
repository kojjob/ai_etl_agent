require 'rails_helper'

RSpec.describe "pipeline_runs/new", type: :view do
  before(:each) do
    assign(:pipeline_run, PipelineRun.new(
      pipeline: nil,
      pipeline_version_at_run: 1,
      status: "MyString",
      triggered_by_type: "MyString",
      triggered_by_user: nil,
      duration_ms: "",
      parameters: "",
      summary_metrics: ""
    ))
  end

  it "renders new pipeline_run form" do
    render

    assert_select "form[action=?][method=?]", pipeline_runs_path, "post" do
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
