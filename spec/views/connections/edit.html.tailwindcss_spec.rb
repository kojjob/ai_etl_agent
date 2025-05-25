require 'rails_helper'

RSpec.describe "connections/edit", type: :view do
  let(:connection) {
    Connection.create!(
      name: "MyString",
      description: "MyText",
      type: "",
      configuration: "",
      test_status: "MyString",
      created_by_user: nil
    )
  }

  before(:each) do
    assign(:connection, connection)
  end

  it "renders the edit connection form" do
    render

    assert_select "form[action=?][method=?]", connection_path(connection), "post" do

      assert_select "input[name=?]", "connection[name]"

      assert_select "textarea[name=?]", "connection[description]"

      assert_select "input[name=?]", "connection[type]"

      assert_select "input[name=?]", "connection[configuration]"

      assert_select "input[name=?]", "connection[test_status]"

      assert_select "input[name=?]", "connection[created_by_user_id]"
    end
  end
end
