require 'rails_helper'

RSpec.describe "dashboard_widgets/new", type: :view do
  before(:each) do
    assign(:dashboard_widget, DashboardWidget.new(
      dashboard: nil,
      widget_type: "MyString",
      title: "MyString",
      configuration: "",
      refresh_interval_seconds: 1
    ))
  end

  it "renders new dashboard_widget form" do
    render

    assert_select "form[action=?][method=?]", dashboard_widgets_path, "post" do
      assert_select "input[name=?]", "dashboard_widget[dashboard_id]"

      assert_select "input[name=?]", "dashboard_widget[widget_type]"

      assert_select "input[name=?]", "dashboard_widget[title]"

      assert_select "input[name=?]", "dashboard_widget[configuration]"

      assert_select "input[name=?]", "dashboard_widget[refresh_interval_seconds]"
    end
  end
end
