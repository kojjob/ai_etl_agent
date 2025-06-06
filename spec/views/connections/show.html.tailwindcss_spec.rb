require 'rails_helper'

RSpec.describe "connections/show", type: :view do
  before(:each) do
    assign(:connection, Connection.create!(
      name: "Name",
      description: "MyText",
      type: "Type",
      configuration: "",
      test_status: "Test Status",
      created_by_user: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Type/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Test Status/)
    expect(rendered).to match(//)
  end
end
