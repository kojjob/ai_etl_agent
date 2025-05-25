class Schedule < ApplicationRecord
  belongs_to :pipeline
  belongs_to :last_triggered_run
  belongs_to :created_by_user
end
