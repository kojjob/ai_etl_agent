require 'rails_helper'

RSpec.describe "projects/new", type: :view do
  before(:each) do
    assign(:project, Project.new(
      name: "MyString",
      description: "MyText",
      created_by_user: nil,
      status: "MyString",
      tags: ""
    ))
  end

  it "renders new project form" do
    render

    assert_select "form[action=?][method=?]", projects_path, "post" do

      assert_select "input[name=?]", "project[name]"

      assert_select "textarea[name=?]", "project[description]"

      assert_select "input[name=?]", "project[created_by_user_id]"

      assert_select "input[name=?]", "project[status]"

      assert_select "input[name=?]", "project[tags]"
    end
  end
end
