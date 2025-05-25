class Pipeline < ApplicationRecord
  belongs_to :created_by_user
  belongs_to :project
end
