require 'rails_helper'

RSpec.describe "dashboards/edit", type: :view do
  let(:dashboard) {
    Dashboard.create!(
      user: nil,
      name: "MyString",
      description: "MyText",
      layout_config: "",
      is_default: false,
      is_shared: false,
      shared_with_roles: ""
    )
  }

  before(:each) do
    assign(:dashboard, dashboard)
  end

  it "renders the edit dashboard form" do
    render

    assert_select "form[action=?][method=?]", dashboard_path(dashboard), "post" do
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
