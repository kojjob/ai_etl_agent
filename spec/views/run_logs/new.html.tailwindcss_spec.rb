require 'rails_helper'

RSpec.describe "run_logs/new", type: :view do
  before(:each) do
    assign(:run_log, RunLog.new(
      pipeline_run: nil,
      pipeline_step_run: nil,
      level: "MyString",
      message: "MyText",
      source: "MyString"
    ))
  end

  it "renders new run_log form" do
    render

    assert_select "form[action=?][method=?]", run_logs_path, "post" do
      assert_select "input[name=?]", "run_log[pipeline_run_id]"

      assert_select "input[name=?]", "run_log[pipeline_step_run_id]"

      assert_select "input[name=?]", "run_log[level]"

      assert_select "textarea[name=?]", "run_log[message]"

      assert_select "input[name=?]", "run_log[source]"
    end
  end
end
