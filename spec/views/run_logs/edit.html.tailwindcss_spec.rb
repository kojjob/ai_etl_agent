require 'rails_helper'

RSpec.describe "run_logs/edit", type: :view do
  let(:run_log) {
    RunLog.create!(
      pipeline_run: nil,
      pipeline_step_run: nil,
      level: "MyString",
      message: "MyText",
      source: "MyString"
    )
  }

  before(:each) do
    assign(:run_log, run_log)
  end

  it "renders the edit run_log form" do
    render

    assert_select "form[action=?][method=?]", run_log_path(run_log), "post" do
      assert_select "input[name=?]", "run_log[pipeline_run_id]"

      assert_select "input[name=?]", "run_log[pipeline_step_run_id]"

      assert_select "input[name=?]", "run_log[level]"

      assert_select "textarea[name=?]", "run_log[message]"

      assert_select "input[name=?]", "run_log[source]"
    end
  end
end
