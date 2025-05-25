require 'rails_helper'

RSpec.describe "alerts/new", type: :view do
  before(:each) do
    assign(:alert, Alert.new(
      pipeline: nil,
      pipeline_run: nil,
      pipeline_step_run: nil,
      rule: nil,
      severity: "MyString",
      message: "MyText",
      status: "MyString",
      acknowledged_by_user: nil
    ))
  end

  it "renders new alert form" do
    render

    assert_select "form[action=?][method=?]", alerts_path, "post" do
      assert_select "input[name=?]", "alert[pipeline_id]"

      assert_select "input[name=?]", "alert[pipeline_run_id]"

      assert_select "input[name=?]", "alert[pipeline_step_run_id]"

      assert_select "input[name=?]", "alert[rule_id]"

      assert_select "input[name=?]", "alert[severity]"

      assert_select "textarea[name=?]", "alert[message]"

      assert_select "input[name=?]", "alert[status]"

      assert_select "input[name=?]", "alert[acknowledged_by_user_id]"
    end
  end
end
