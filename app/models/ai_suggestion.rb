class AiSuggestion < ApplicationRecord
  belongs_to :user
  belongs_to :context_entity, polymorphic: true
end
