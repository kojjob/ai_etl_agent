require 'rails_helper'

RSpec.describe "system_settings/edit", type: :view do
  let(:system_setting) {
    SystemSetting.create!(
      setting_key: "MyString",
      setting_value: "",
      description: "MyText",
      is_sensitive: false
    )
  }

  before(:each) do
    assign(:system_setting, system_setting)
  end

  it "renders the edit system_setting form" do
    render

    assert_select "form[action=?][method=?]", system_setting_path(system_setting), "post" do
      assert_select "input[name=?]", "system_setting[setting_key]"

      assert_select "input[name=?]", "system_setting[setting_value]"

      assert_select "textarea[name=?]", "system_setting[description]"

      assert_select "input[name=?]", "system_setting[is_sensitive]"
    end
  end
end
