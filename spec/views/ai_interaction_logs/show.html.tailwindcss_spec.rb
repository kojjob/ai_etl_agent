require 'rails_helper'

RSpec.describe "ai_interaction_logs/show", type: :view do
  before(:each) do
    assign(:ai_interaction_log, AiInteractionLog.create!(
      user: nil,
      session_id: "",
      user_query: "MyText",
      ai_response: "MyText",
      interaction_type: "Interaction Type",
      context_entity: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Interaction Type/)
    expect(rendered).to match(//)
  end
end
