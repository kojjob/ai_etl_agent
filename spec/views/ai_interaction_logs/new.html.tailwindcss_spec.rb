require 'rails_helper'

RSpec.describe "ai_interaction_logs/new", type: :view do
  before(:each) do
    assign(:ai_interaction_log, AiInteractionLog.new(
      user: nil,
      session_id: "",
      user_query: "MyText",
      ai_response: "MyText",
      interaction_type: "MyString",
      context_entity: nil
    ))
  end

  it "renders new ai_interaction_log form" do
    render

    assert_select "form[action=?][method=?]", ai_interaction_logs_path, "post" do

      assert_select "input[name=?]", "ai_interaction_log[user_id]"

      assert_select "input[name=?]", "ai_interaction_log[session_id]"

      assert_select "textarea[name=?]", "ai_interaction_log[user_query]"

      assert_select "textarea[name=?]", "ai_interaction_log[ai_response]"

      assert_select "input[name=?]", "ai_interaction_log[interaction_type]"

      assert_select "input[name=?]", "ai_interaction_log[context_entity_id]"
    end
  end
end
