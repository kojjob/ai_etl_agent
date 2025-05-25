require 'rails_helper'

RSpec.describe "ai_suggestions/edit", type: :view do
  let(:ai_suggestion) {
    AiSuggestion.create!(
      user: nil,
      session_id: "",
      context_entity: nil,
      suggestion_prompt: "MyText",
      suggestion_content: "",
      suggestion_type: "MyString",
      confidence_score: 1.5,
      status: "MyString",
      feedback_rating: 1,
      feedback_text: "MyText"
    )
  }

  before(:each) do
    assign(:ai_suggestion, ai_suggestion)
  end

  it "renders the edit ai_suggestion form" do
    render

    assert_select "form[action=?][method=?]", ai_suggestion_path(ai_suggestion), "post" do

      assert_select "input[name=?]", "ai_suggestion[user_id]"

      assert_select "input[name=?]", "ai_suggestion[session_id]"

      assert_select "input[name=?]", "ai_suggestion[context_entity_id]"

      assert_select "textarea[name=?]", "ai_suggestion[suggestion_prompt]"

      assert_select "input[name=?]", "ai_suggestion[suggestion_content]"

      assert_select "input[name=?]", "ai_suggestion[suggestion_type]"

      assert_select "input[name=?]", "ai_suggestion[confidence_score]"

      assert_select "input[name=?]", "ai_suggestion[status]"

      assert_select "input[name=?]", "ai_suggestion[feedback_rating]"

      assert_select "textarea[name=?]", "ai_suggestion[feedback_text]"
    end
  end
end
