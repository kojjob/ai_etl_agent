require 'rails_helper'

RSpec.describe "dashboard_widgets/edit", type: :view do
  let(:dashboard_widget) {
    DashboardWidget.create!(
      dashboard: nil,
      widget_type: "MyString",
      title: "MyString",
      configuration: "",
      refresh_interval_seconds: 1
    )
  }

  before(:each) do
    assign(:dashboard_widget, dashboard_widget)
  end

  it "renders the edit dashboard_widget form" do
    render

    assert_select "form[action=?][method=?]", dashboard_widget_path(dashboard_widget), "post" do
      assert_select "input[name=?]", "dashboard_widget[dashboard_id]"

      assert_select "input[name=?]", "dashboard_widget[widget_type]"

      assert_select "input[name=?]", "dashboard_widget[title]"

      assert_select "input[name=?]", "dashboard_widget[configuration]"

      assert_select "input[name=?]", "dashboard_widget[refresh_interval_seconds]"
    end
  end
end
