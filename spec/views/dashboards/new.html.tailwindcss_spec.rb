require 'rails_helper'

RSpec.describe "dashboards/new", type: :view do
  before(:each) do
    assign(:dashboard, Dashboard.new(
      user: nil,
      name: "MyString",
      description: "MyText",
      layout_config: "",
      is_default: false,
      is_shared: false,
      shared_with_roles: ""
    ))
  end

  it "renders new dashboard form" do
    render

    assert_select "form[action=?][method=?]", dashboards_path, "post" do

      assert_select "input[name=?]", "dashboard[user_id]"

      assert_select "input[name=?]", "dashboard[name]"

      assert_select "textarea[name=?]", "dashboard[description]"

      assert_select "input[name=?]", "dashboard[layout_config]"

      assert_select "input[name=?]", "dashboard[is_default]"

      assert_select "input[name=?]", "dashboard[is_shared]"

      assert_select "input[name=?]", "dashboard[shared_with_roles]"
    end
  end
end
