require 'rails_helper'

RSpec.describe "projects/edit", type: :view do
  let(:project) {
    Project.create!(
      name: "MyString",
      description: "MyText",
      created_by_user: nil,
      status: "MyString",
      tags: ""
    )
  }

  before(:each) do
    assign(:project, project)
  end

  it "renders the edit project form" do
    render

    assert_select "form[action=?][method=?]", project_path(project), "post" do
      assert_select "input[name=?]", "project[name]"

      assert_select "textarea[name=?]", "project[description]"

      assert_select "input[name=?]", "project[created_by_user_id]"

      assert_select "input[name=?]", "project[status]"

      assert_select "input[name=?]", "project[tags]"
    end
  end
end
