require 'rails_helper'

RSpec.describe "pipelines/index", type: :view do
  before(:each) do
    assign(:pipelines, [
      Pipeline.create!(
        name: "Name",
        description: "MyText",
        created_by_user: nil,
        project: nil,
        version: 2,
        status: "Status",
        tags: "",
        ai_assisted_design_details: ""
      ),
      Pipeline.create!(
        name: "Name",
        description: "MyText",
        created_by_user: nil,
        project: nil,
        version: 2,
        status: "Status",
        tags: "",
        ai_assisted_design_details: ""
      )
    ])
  end

  it "renders a list of pipelines" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Status".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
  end
end
