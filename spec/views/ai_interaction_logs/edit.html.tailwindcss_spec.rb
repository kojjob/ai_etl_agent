require 'rails_helper'

RSpec.describe "ai_interaction_logs/edit", type: :view do
  let(:ai_interaction_log) {
    AiInteractionLog.create!(
      user: nil,
      session_id: "",
      user_query: "MyText",
      ai_response: "MyText",
      interaction_type: "MyString",
      context_entity: nil
    )
  }

  before(:each) do
    assign(:ai_interaction_log, ai_interaction_log)
  end

  it "renders the edit ai_interaction_log form" do
    render

    assert_select "form[action=?][method=?]", ai_interaction_log_path(ai_interaction_log), "post" do

      assert_select "input[name=?]", "ai_interaction_log[user_id]"

      assert_select "input[name=?]", "ai_interaction_log[session_id]"

      assert_select "textarea[name=?]", "ai_interaction_log[user_query]"

      assert_select "textarea[name=?]", "ai_interaction_log[ai_response]"

      assert_select "input[name=?]", "ai_interaction_log[interaction_type]"

      assert_select "input[name=?]", "ai_interaction_log[context_entity_id]"
    end
  end
end
