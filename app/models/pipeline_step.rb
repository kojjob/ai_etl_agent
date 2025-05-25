class PipelineStep < ApplicationRecord
  belongs_to :pipeline
  belongs_to :source_connection
  belongs_to :target_connection
end
