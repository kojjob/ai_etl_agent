require 'rails_helper'

RSpec.describe "system_settings/show", type: :view do
  before(:each) do
    assign(:system_setting, SystemSetting.create!(
      setting_key: "Setting Key",
      setting_value: "",
      description: "MyText",
      is_sensitive: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Setting Key/)
    expect(rendered).to match(//)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/false/)
  end
end
