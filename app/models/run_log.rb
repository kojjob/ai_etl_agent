class RunLog < ApplicationRecord
  belongs_to :pipeline_run
  belongs_to :pipeline_step_run
end
