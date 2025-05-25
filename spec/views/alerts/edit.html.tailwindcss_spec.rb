require 'rails_helper'

RSpec.describe "alerts/edit", type: :view do
  let(:alert) {
    Alert.create!(
      pipeline: nil,
      pipeline_run: nil,
      pipeline_step_run: nil,
      rule: nil,
      severity: "MyString",
      message: "MyText",
      status: "MyString",
      acknowledged_by_user: nil
    )
  }

  before(:each) do
    assign(:alert, alert)
  end

  it "renders the edit alert form" do
    render

    assert_select "form[action=?][method=?]", alert_path(alert), "post" do
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
