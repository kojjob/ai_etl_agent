class PipelineRun < ApplicationRecord
  belongs_to :pipeline
  belongs_to :triggered_by_user
end
