require 'rails_helper'

RSpec.describe "system_settings/index", type: :view do
  before(:each) do
    assign(:system_settings, [
      SystemSetting.create!(
        setting_key: "Setting Key",
        setting_value: "",
        description: "MyText",
        is_sensitive: false
      ),
      SystemSetting.create!(
        setting_key: "Setting Key",
        setting_value: "",
        description: "MyText",
        is_sensitive: false
      )
    ])
  end

  it "renders a list of system_settings" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Setting Key".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
