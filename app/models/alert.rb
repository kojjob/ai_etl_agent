class Alert < ApplicationRecord
  belongs_to :pipeline
  belongs_to :pipeline_run
  belongs_to :pipeline_step_run
  belongs_to :rule
  belongs_to :acknowledged_by_user
end
