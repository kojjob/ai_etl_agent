class PipelineStepRun < ApplicationRecord
  belongs_to :pipeline_run
  belongs_to :pipeline_step
end
