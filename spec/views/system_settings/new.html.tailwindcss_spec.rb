require 'rails_helper'

RSpec.describe "system_settings/new", type: :view do
  before(:each) do
    assign(:system_setting, SystemSetting.new(
      setting_key: "MyString",
      setting_value: "",
      description: "MyText",
      is_sensitive: false
    ))
  end

  it "renders new system_setting form" do
    render

    assert_select "form[action=?][method=?]", system_settings_path, "post" do
      assert_select "input[name=?]", "system_setting[setting_key]"

      assert_select "input[name=?]", "system_setting[setting_value]"

      assert_select "textarea[name=?]", "system_setting[description]"

      assert_select "input[name=?]", "system_setting[is_sensitive]"
    end
  end
end
