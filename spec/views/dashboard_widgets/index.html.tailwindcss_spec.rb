require 'rails_helper'

RSpec.describe "dashboard_widgets/index", type: :view do
  before(:each) do
    assign(:dashboard_widgets, [
      DashboardWidget.create!(
        dashboard: nil,
        widget_type: "Widget Type",
        title: "Title",
        configuration: "",
        refresh_interval_seconds: 2
      ),
      DashboardWidget.create!(
        dashboard: nil,
        widget_type: "Widget Type",
        title: "Title",
        configuration: "",
        refresh_interval_seconds: 2
      )
    ])
  end

  it "renders a list of dashboard_widgets" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Widget Type".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Title".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
  end
end
