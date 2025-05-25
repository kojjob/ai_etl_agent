require 'rails_helper'

RSpec.describe "dashboards/index", type: :view do
  before(:each) do
    assign(:dashboards, [
      Dashboard.create!(
        user: nil,
        name: "Name",
        description: "MyText",
        layout_config: "",
        is_default: false,
        is_shared: false,
        shared_with_roles: ""
      ),
      Dashboard.create!(
        user: nil,
        name: "Name",
        description: "MyText",
        layout_config: "",
        is_default: false,
        is_shared: false,
        shared_with_roles: ""
      )
    ])
  end

  it "renders a list of dashboards" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
  end
end
