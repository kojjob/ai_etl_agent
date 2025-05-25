require 'rails_helper'

RSpec.describe "dashboards/show", type: :view do
  before(:each) do
    assign(:dashboard, Dashboard.create!(
      user: nil,
      name: "Name",
      description: "MyText",
      layout_config: "",
      is_default: false,
      is_shared: false,
      shared_with_roles: ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(//)
  end
end
