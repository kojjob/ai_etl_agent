require 'rails_helper'

RSpec.describe "dashboard_widgets/show", type: :view do
  before(:each) do
    assign(:dashboard_widget, DashboardWidget.create!(
      dashboard: nil,
      widget_type: "Widget Type",
      title: "Title",
      configuration: "",
      refresh_interval_seconds: 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Widget Type/)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(//)
    expect(rendered).to match(/2/)
  end
end
