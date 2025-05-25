require 'rails_helper'

RSpec.describe "schedules/new", type: :view do
  before(:each) do
    assign(:schedule, Schedule.new(
      pipeline: nil,
      cron_expression: "MyString",
      timezone: "MyString",
      is_active: false,
      last_triggered_run: nil,
      created_by_user: nil
    ))
  end

  it "renders new schedule form" do
    render

    assert_select "form[action=?][method=?]", schedules_path, "post" do

      assert_select "input[name=?]", "schedule[pipeline_id]"

      assert_select "input[name=?]", "schedule[cron_expression]"

      assert_select "input[name=?]", "schedule[timezone]"

      assert_select "input[name=?]", "schedule[is_active]"

      assert_select "input[name=?]", "schedule[last_triggered_run_id]"

      assert_select "input[name=?]", "schedule[created_by_user_id]"
    end
  end
end
