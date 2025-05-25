require 'rails_helper'

RSpec.describe "connections/index", type: :view do
  before(:each) do
    assign(:connections, [
      Connection.create!(
        name: "Name",
        description: "MyText",
        type: "Type",
        configuration: "",
        test_status: "Test Status",
        created_by_user: nil
      ),
      Connection.create!(
        name: "Name",
        description: "MyText",
        type: "Type",
        configuration: "",
        test_status: "Test Status",
        created_by_user: nil
      )
    ])
  end

  it "renders a list of connections" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Type".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Test Status".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
