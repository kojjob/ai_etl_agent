require 'rails_helper'

RSpec.describe "pipelines/show", type: :view do
  before(:each) do
    assign(:pipeline, Pipeline.create!(
      name: "Name",
      description: "MyText",
      created_by_user: nil,
      project: nil,
      version: 2,
      status: "Status",
      tags: "",
      ai_assisted_design_details: ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Status/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
