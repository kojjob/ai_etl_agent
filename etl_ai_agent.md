# Complete Rails 8 AI ETL Agent Implementation Guide

## Table of Contents
1. [Project Setup](#1-project-setup)
2. [Data Models & Associations](#2-data-models--associations)
3. [Database Schema Implementation](#3-database-schema-implementation)
4. [Service Layer Architecture](#4-service-layer-architecture)
5. [Background Job Processing](#5-background-job-processing)
6. [Controllers & Routes](#6-controllers--routes)
7. [Hotwire Frontend Implementation](#7-hotwire-frontend-implementation)
8. [Action Cable Integration](#8-action-cable-integration)
9. [File Upload & Processing](#9-file-upload--processing)
10. [Testing & Running](#10-testing--running)
11. [Production Considerations](#11-production-considerations)

---

## 1. Project Setup

### Prerequisites
- Ruby 3.2+
- Rails 8.0+ (or Rails 7.1+ with Hotwire)
- PostgreSQL 14+
- Redis (for Action Cable and Sidekiq)
- Node.js 18+ and Yarn

### Initial Project Creation

```bash
# Create new Rails application with modern defaults
rails new ai_etl_agent \
  --database=postgresql \
  --css=tailwind \
  --javascript=esbuild \
  --skip-test

cd ai_etl_agent
```

### Gemfile Configuration

```ruby
# Gemfile
source "https://rubygems.org"

ruby "3.2.2"

# Core Rails gems
gem "rails", "~> 8.0.0"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "redis", ">= 4.0.1"

# CSS Framework
gem "tailwindcss-rails"

# Background Processing
gem "sidekiq", "~> 7.0"
gem "sidekiq-cron"

# File Processing
gem "image_processing", "~> 1.2"
gem "rubyXL" # For Excel processing
gem "roo" # Alternative Excel/CSV processor

# Authentication & Authorization
gem "devise"
gem "pundit"

# API Clients (for future LLM integration)
gem "faraday"
gem "faraday-retry"

# Utilities
gem "bootsnap", ">= 1.4.4", require: false
gem "tzinfo-data", platforms: %i[ windows jruby ]

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "dotenv-rails"
end

group :development do
  gem "web-console"
  gem "listen", "~> 3.3"
  gem "spring"
  gem "annotate"
  gem "better_errors"
  gem "binding_of_caller"
  gem "rails-erd"
end
```

### Initial Setup Commands

```bash
# Install dependencies
bundle install

# Create databases
rails db:create

# Install Action Text (for rich text in messages)
rails action_text:install

# Install Active Storage (for file uploads)
rails active_storage:install

# Install Devise for authentication
rails generate devise:install

# Configure Tailwind CSS
rails tailwindcss:install

# Setup Sidekiq
bundle exec rails generate sidekiq:job
```

### Environment Configuration

```bash
# .env.development
DATABASE_URL=postgresql://localhost/ai_etl_agent_development
REDIS_URL=redis://localhost:6379/0
RAILS_MASTER_KEY=your_master_key_here

# Future LLM API keys
OPENAI_API_KEY=your_openai_key_here
ANTHROPIC_API_KEY=your_anthropic_key_here
```

---

## 2. Data Models & Associations

### Domain Model Overview

```ruby
# Core domain models and their relationships
# User ---- has_many ----> Messages
#      ---- has_many ----> DataSources
#      ---- has_many ----> Pipelines
#      ---- has_many ----> Sessions
#
# Session ---- has_many ----> Messages
#         ---- has_many ----> PipelineRuns
#
# DataSource ---- has_many ----> Pipelines (through PipelineDataSources)
#            ---- has_one_attached ----> file
#
# Pipeline ---- has_many ----> PipelineSteps
#          ---- has_many ----> PipelineRuns
#          ---- has_many ----> DataSources (through PipelineDataSources)
#
# PipelineRun ---- has_many ----> RunLogs
#             ---- belongs_to ----> Session
#             ---- has_many_attached ----> artifacts
#
# Message ---- belongs_to ----> Session
#         ---- belongs_to ----> User
#         ---- has_rich_text ----> content
#         ---- has_one_attached ----> attachment
```

### Detailed Model Definitions

```ruby
# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :messages, dependent: :destroy
  has_many :sessions, dependent: :destroy
  has_many :data_sources, dependent: :destroy
  has_many :pipelines, dependent: :destroy
  
  validates :email, presence: true, uniqueness: true
end

# app/models/session.rb
class Session < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy
  has_many :pipeline_runs, dependent: :destroy
  
  validates :session_id, presence: true, uniqueness: true
  
  before_validation :generate_session_id, on: :create
  
  private
  
  def generate_session_id
    self.session_id ||= SecureRandom.uuid
  end
end

# app/models/message.rb
class Message < ApplicationRecord
  belongs_to :session
  belongs_to :user
  has_rich_text :content
  has_one_attached :attachment
  
  enum role: { user: 0, assistant: 1, system: 2 }
  enum status: { pending: 0, processing: 1, completed: 2, failed: 3 }
  
  validates :role, presence: true
  validates :content, presence: true
  
  scope :conversation_order, -> { order(created_at: :asc) }
  
  after_create_commit :broadcast_message
  
  private
  
  def broadcast_message
    broadcast_append_to(
      "session_#{session_id}_messages",
      target: "messages",
      partial: "messages/message",
      locals: { message: self }
    )
  end
end

# app/models/data_source.rb
class DataSource < ApplicationRecord
  belongs_to :user
  has_one_attached :file
  has_many :pipeline_data_sources, dependent: :destroy
  has_many :pipelines, through: :pipeline_data_sources
  
  enum source_type: { csv: 0, excel: 1, json: 2, api: 3, database: 4 }
  enum status: { active: 0, inactive: 1, error: 2 }
  
  validates :name, presence: true
  validates :source_type, presence: true
  
  store_accessor :configuration, :headers, :delimiter, :encoding
  store_accessor :metadata, :row_count, :column_count, :file_size, :last_modified
end

# app/models/pipeline.rb
class Pipeline < ApplicationRecord
  belongs_to :user
  has_many :pipeline_steps, dependent: :destroy
  has_many :pipeline_runs, dependent: :destroy
  has_many :pipeline_data_sources, dependent: :destroy
  has_many :data_sources, through: :pipeline_data_sources
  
  enum status: { draft: 0, active: 1, inactive: 2, archived: 3 }
  
  validates :name, presence: true
  validates :status, presence: true
  
  store_accessor :configuration, :schedule, :retry_policy, :notification_settings
end

# app/models/pipeline_step.rb
class PipelineStep < ApplicationRecord
  belongs_to :pipeline
  
  enum step_type: { 
    extract: 0, 
    transform: 1, 
    load: 2, 
    validate: 3, 
    aggregate: 4,
    filter: 5,
    join: 6,
    custom: 7
  }
  
  validates :name, presence: true
  validates :step_type, presence: true
  validates :position, presence: true, uniqueness: { scope: :pipeline_id }
  
  store_accessor :configuration, :operation, :parameters, :error_handling
  
  scope :ordered, -> { order(position: :asc) }
end

# app/models/pipeline_run.rb
class PipelineRun < ApplicationRecord
  belongs_to :pipeline
  belongs_to :session, optional: true
  has_many :run_logs, dependent: :destroy
  has_many_attached :artifacts
  
  enum status: { 
    queued: 0, 
    running: 1, 
    completed: 2, 
    failed: 3, 
    cancelled: 4 
  }
  
  validates :status, presence: true
  
  store_accessor :metadata, :start_time, :end_time, :duration, :records_processed
  store_accessor :results, :summary, :errors, :warnings
end

# app/models/run_log.rb
class RunLog < ApplicationRecord
  belongs_to :pipeline_run
  
  enum log_level: { debug: 0, info: 1, warning: 2, error: 3, fatal: 4 }
  
  validates :log_level, presence: true
  validates :message, presence: true
  
  scope :recent, -> { order(created_at: :desc) }
  scope :errors_only, -> { where(log_level: [:error, :fatal]) }
end

# Join Tables
# app/models/pipeline_data_source.rb
class PipelineDataSource < ApplicationRecord
  belongs_to :pipeline
  belongs_to :data_source
  
  validates :pipeline_id, uniqueness: { scope: :data_source_id }
end
```

---

## 3. Database Schema Implementation

### Create All Migrations

```bash
# Generate all migrations
rails generate devise User
rails generate migration CreateSessions
rails generate migration CreateMessages
rails generate migration CreateDataSources
rails generate migration CreatePipelines
rails generate migration CreatePipelineSteps
rails generate migration CreatePipelineRuns
rails generate migration CreateRunLogs
rails generate migration CreatePipelineDataSources
rails generate migration AddJsonbFieldsToModels
```

### Migration Files

```ruby
# db/migrate/xxx_create_sessions.rb
class CreateSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :session_id, null: false
      t.string :title
      t.jsonb :metadata, default: {}
      t.timestamps
    end
    
    add_index :sessions, :session_id, unique: true
    add_index :sessions, :metadata, using: :gin
  end
end

# db/migrate/xxx_create_messages.rb
class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.references :session, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :role, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.jsonb :metadata, default: {}
      t.timestamps
    end
    
    add_index :messages, :role
    add_index :messages, :status
    add_index :messages, [:session_id, :created_at]
  end
end

# db/migrate/xxx_create_data_sources.rb
class CreateDataSources < ActiveRecord::Migration[7.1]
  def change
    create_table :data_sources do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.integer :source_type, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.jsonb :configuration, default: {}
      t.jsonb :metadata, default: {}
      t.timestamps
    end
    
    add_index :data_sources, :source_type
    add_index :data_sources, :status
    add_index :data_sources, :configuration, using: :gin
  end
end

# db/migrate/xxx_create_pipelines.rb
class CreatePipelines < ActiveRecord::Migration[7.1]
  def change
    create_table :pipelines do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.integer :status, null: false, default: 0
      t.jsonb :configuration, default: {}
      t.timestamps
    end
    
    add_index :pipelines, :status
    add_index :pipelines, :configuration, using: :gin
  end
end

# db/migrate/xxx_create_pipeline_steps.rb
class CreatePipelineSteps < ActiveRecord::Migration[7.1]
  def change
    create_table :pipeline_steps do |t|
      t.references :pipeline, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.integer :step_type, null: false, default: 0
      t.integer :position, null: false
      t.jsonb :configuration, default: {}
      t.timestamps
    end
    
    add_index :pipeline_steps, [:pipeline_id, :position], unique: true
    add_index :pipeline_steps, :step_type
  end
end

# db/migrate/xxx_create_pipeline_runs.rb
class CreatePipelineRuns < ActiveRecord::Migration[7.1]
  def change
    create_table :pipeline_runs do |t|
      t.references :pipeline, null: false, foreign_key: true
      t.references :session, foreign_key: true
      t.integer :status, null: false, default: 0
      t.datetime :started_at
      t.datetime :completed_at
      t.jsonb :metadata, default: {}
      t.jsonb :results, default: {}
      t.timestamps
    end
    
    add_index :pipeline_runs, :status
    add_index :pipeline_runs, [:pipeline_id, :created_at]
  end
end

# db/migrate/xxx_create_run_logs.rb
class CreateRunLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :run_logs do |t|
      t.references :pipeline_run, null: false, foreign_key: true
      t.integer :log_level, null: false, default: 1
      t.string :step_name
      t.text :message, null: false
      t.jsonb :context, default: {}
      t.timestamps
    end
    
    add_index :run_logs, :log_level
    add_index :run_logs, [:pipeline_run_id, :created_at]
  end
end

# db/migrate/xxx_create_pipeline_data_sources.rb
class CreatePipelineDataSources < ActiveRecord::Migration[7.1]
  def change
    create_table :pipeline_data_sources do |t|
      t.references :pipeline, null: false, foreign_key: true
      t.references :data_source, null: false, foreign_key: true
      t.timestamps
    end
    
    add_index :pipeline_data_sources, [:pipeline_id, :data_source_id], unique: true
  end
end
```

### Run Migrations

```bash
# Run all migrations
rails db:migrate

# Generate schema documentation
rails erd
```

---

## 4. Service Layer Architecture

### Core Service Objects

```ruby
# app/services/application_service.rb
class ApplicationService
  def self.call(...)
    new(...).call
  end
end

# app/services/ai_service.rb
class AiService < ApplicationService
  attr_reader :message, :session, :context

  def initialize(message, session, context = {})
    @message = message
    @session = session
    @context = context
  end

  def call
    analyze_query
    determine_intent
    execute_action
    generate_response
  end

  private

  def analyze_query
    @analyzed_query = QueryAnalyzer.new(message.content.to_plain_text).analyze
  end

  def determine_intent
    @intent = IntentClassifier.new(@analyzed_query).classify
  end

  def execute_action
    @action_result = case @intent[:type]
    when :data_query
      DataQueryService.call(message, @intent[:parameters])
    when :pipeline_creation
      PipelineCreationService.call(message, @intent[:parameters])
    when :visualization
      VisualizationService.call(message, @intent[:parameters])
    else
      { success: true, data: nil }
    end
  end

  def generate_response
    ResponseGenerator.new(
      intent: @intent,
      action_result: @action_result,
      context: @context
    ).generate
  end
end

# app/services/query_analyzer.rb
class QueryAnalyzer < ApplicationService
  attr_reader :query

  def initialize(query)
    @query = query
  end

  def analyze
    {
      original: query,
      normalized: normalize_query,
      tokens: tokenize,
      entities: extract_entities,
      keywords: extract_keywords
    }
  end

  private

  def normalize_query
    query.downcase.strip.gsub(/[^\w\s]/, '')
  end

  def tokenize
    normalize_query.split(/\s+/)
  end

  def extract_entities
    # Simple entity extraction - in production, use NLP libraries
    {
      data_references: query.scan(/(?:csv|excel|json|data|file|table)/i),
      operations: query.scan(/(?:sum|average|count|filter|group|join)/i),
      columns: query.scan(/(?:sales|revenue|customer|product|date)/i)
    }
  end

  def extract_keywords
    # Extract action keywords
    keywords = []
    keywords << :query if query.match?(/what|show|tell|find|get/i)
    keywords << :create if query.match?(/create|make|build|generate/i)
    keywords << :update if query.match?(/update|modify|change|edit/i)
    keywords << :delete if query.match?(/delete|remove|drop/i)
    keywords
  end
end

# app/services/intent_classifier.rb
class IntentClassifier < ApplicationService
  INTENT_PATTERNS = {
    data_query: [
      /(?:what|show|tell).+(?:total|sum|average|count)/i,
      /(?:how many|how much)/i,
      /(?:list|display|show).+(?:top|bottom|best|worst)/i
    ],
    pipeline_creation: [
      /(?:create|build|make).+(?:pipeline|etl|workflow)/i,
      /(?:set up|configure).+(?:data|import|export)/i
    ],
    visualization: [
      /(?:chart|graph|plot|visualize)/i,
      /(?:show|create).+(?:dashboard|report)/i
    ],
    file_upload: [
      /(?:upload|import|load).+(?:file|data|csv|excel)/i
    ],
    greeting: [
      /^(?:hi|hello|hey|good morning|good afternoon)/i
    ]
  }.freeze

  attr_reader :analyzed_query

  def initialize(analyzed_query)
    @analyzed_query = analyzed_query
  end

  def classify
    INTENT_PATTERNS.each do |intent_type, patterns|
      patterns.each do |pattern|
        if analyzed_query[:original].match?(pattern)
          return build_intent(intent_type)
        end
      end
    end

    { type: :unknown, confidence: 0.0, parameters: {} }
  end

  private

  def build_intent(type)
    {
      type: type,
      confidence: calculate_confidence(type),
      parameters: extract_parameters(type)
    }
  end

  def calculate_confidence(type)
    # Simple confidence calculation - enhance with ML in production
    case type
    when :greeting then 1.0
    when :file_upload then 0.9
    else 0.7
    end
  end

  def extract_parameters(type)
    case type
    when :data_query
      {
        operation: analyzed_query[:entities][:operations].first,
        columns: analyzed_query[:entities][:columns],
        filters: extract_filters
      }
    when :visualization
      {
        chart_type: detect_chart_type,
        data_source: analyzed_query[:entities][:data_references].first
      }
    else
      {}
    end
  end

  def extract_filters
    # Extract filter conditions from query
    filters = []
    if match = analyzed_query[:original].match(/where\s+(\w+)\s*(=|>|<|>=|<=)\s*(.+?)(?:\s|$)/i)
      filters << {
        column: match[1],
        operator: match[2],
        value: match[3]
      }
    end
    filters
  end

  def detect_chart_type
    return :bar if analyzed_query[:original].match?(/bar|column/i)
    return :line if analyzed_query[:original].match?(/line|trend/i)
    return :pie if analyzed_query[:original].match?(/pie|donut/i)
    :bar # default
  end
end

# app/services/data_query_service.rb
class DataQueryService < ApplicationService
  attr_reader :message, :parameters

  def initialize(message, parameters)
    @message = message
    @parameters = parameters
  end

  def call
    load_data_source
    apply_query
    format_results
  rescue StandardError => e
    { success: false, error: e.message }
  end

  private

  def load_data_source
    @data_source = find_relevant_data_source
    @data = DataLoader.new(@data_source).load
  end

  def find_relevant_data_source
    # Find the most recent data source for the session
    message.session.messages
      .joins(:attachment_blob)
      .where.not(attachment_blobs: { id: nil })
      .order(created_at: :desc)
      .first
      &.attachment
  end

  def apply_query
    @results = case parameters[:operation]
    when 'sum'
      calculate_sum
    when 'average'
      calculate_average
    when 'count'
      calculate_count
    else
      @data
    end
  end

  def calculate_sum
    column = parameters[:columns]&.first || 'amount'
    @data.sum { |row| row[column].to_f }
  end

  def calculate_average
    column = parameters[:columns]&.first || 'amount'
    sum = @data.sum { |row| row[column].to_f }
    sum / @data.size.to_f
  end

  def calculate_count
    @data.size
  end

  def format_results
    {
      success: true,
      data: @results,
      summary: generate_summary,
      visualization: prepare_visualization_data
    }
  end

  def generate_summary
    "Processed #{@data.size} records with operation: #{parameters[:operation]}"
  end

  def prepare_visualization_data
    {
      type: :bar,
      data: @results,
      options: {
        title: "Query Results"
      }
    }
  end
end

# app/services/data_loader.rb
class DataLoader < ApplicationService
  attr_reader :source

  def initialize(source)
    @source = source
  end

  def load
    return [] unless source

    case detect_file_type
    when :csv
      load_csv
    when :excel
      load_excel
    when :json
      load_json
    else
      raise "Unsupported file type"
    end
  end

  private

  def detect_file_type
    extension = File.extname(source.filename.to_s).downcase
    case extension
    when '.csv' then :csv
    when '.xlsx', '.xls' then :excel
    when '.json' then :json
    else :unknown
    end
  end

  def load_csv
    csv_content = source.download
    CSV.parse(csv_content, headers: true).map(&:to_h)
  end

  def load_excel
    # Using Roo gem for Excel parsing
    file = Tempfile.new(['excel', '.xlsx'])
    file.binmode
    file.write(source.download)
    file.rewind
    
    spreadsheet = Roo::Spreadsheet.open(file.path)
    headers = spreadsheet.row(1)
    
    (2..spreadsheet.last_row).map do |i|
      row_data = spreadsheet.row(i)
      headers.zip(row_data).to_h
    end
  ensure
    file&.close
    file&.unlink
  end

  def load_json
    JSON.parse(source.download)
  end
end

# app/services/response_generator.rb
class ResponseGenerator < ApplicationService
  attr_reader :intent, :action_result, :context

  def initialize(intent:, action_result:, context: {})
    @intent = intent
    @action_result = action_result
    @context = context
  end

  def generate
    {
      text: generate_text_response,
      data: action_result[:data],
      visualization: action_result[:visualization],
      suggestions: generate_suggestions
    }
  end

  private

  def generate_text_response
    case intent[:type]
    when :greeting
      "Hello! I'm your AI ETL assistant. I can help you analyze data, create pipelines, and generate visualizations. What would you like to do today?"
    when :data_query
      format_data_query_response
    when :pipeline_creation
      "I'll help you create a data pipeline. Let me gather some information first..."
    when :visualization
      "Creating your visualization..."
    when :unknown
      "I'm not sure what you're asking. Could you rephrase your question? I can help with data analysis, creating ETL pipelines, and generating visualizations."
    else
      "How can I assist you with your data today?"
    end
  end

  def format_data_query_response
    if action_result[:success]
      "Based on your data, #{action_result[:summary]}. The result is: **#{format_result(action_result[:data])}**"
    else
      "I encountered an error: #{action_result[:error]}"
    end
  end

  def format_result(data)
    case data
    when Numeric
      number_with_delimiter(data.round(2))
    when Array
      "#{data.size} items"
    when Hash
      data.to_json
    else
      data.to_s
    end
  end

  def generate_suggestions
    suggestions = []
    
    case intent[:type]
    when :data_query
      suggestions << "Try asking about different metrics"
      suggestions << "Create a visualization of this data"
      suggestions << "Export these results"
    when :greeting
      suggestions << "Upload a CSV or Excel file"
      suggestions << "Ask about your total sales"
      suggestions << "Create a new data pipeline"
    end
    
    suggestions
  end

  def number_with_delimiter(number)
    number.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, '\\1,')
  end
end
```

---

## 5. Background Job Processing

### Sidekiq Configuration

```ruby
# config/initializers/sidekiq.rb
Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') }
  
  config.on(:startup) do
    # Load cron jobs if using sidekiq-cron
    Sidekiq::Cron::Job.load_from_hash(YAML.load_file('config/sidekiq_cron.yml')) if File.exist?('config/sidekiq_cron.yml')
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') }
end

# config/sidekiq_cron.yml
cleanup_old_sessions:
  cron: "0 2 * * *"
  class: "CleanupOldSessionsJob"
  description: "Clean up sessions older than 30 days"

process_scheduled_pipelines:
  cron: "*/5 * * * *"
  class: "ProcessScheduledPipelinesJob"
  description: "Check and run scheduled pipelines"
```

### Background Jobs

```ruby
# app/jobs/process_ai_query_job.rb
class ProcessAiQueryJob < ApplicationJob
  queue_as :ai_processing
  
  retry_on StandardError, wait: 5.seconds, attempts: 3
  
  def perform(message_id)
    message = Message.find(message_id)
    return if message.completed?
    
    message.update!(status: :processing)
    
    # Process the query through AI service
    result = AiService.call(message, message.session)
    
    # Create AI response message
    response_message = create_response_message(message, result)
    
    # Update original message status
    message.update!(status: :completed)
    
    # Trigger any follow-up actions
    handle_follow_up_actions(response_message, result)
  rescue StandardError => e
    message.update!(status: :failed)
    ErrorNotificationService.call(e, context: { message_id: message_id })
    raise
  end
  
  private
  
  def create_response_message(user_message, result)
    Message.create!(
      session: user_message.session,
      user: user_message.user,
      role: :assistant,
      content: result[:text],
      metadata: {
        intent: result[:intent],
        data: result[:data],
        visualization: result[:visualization]
      }
    )
  end
  
  def handle_follow_up_actions(message, result)
    if result[:visualization].present?
      GenerateVisualizationJob.perform_later(message.id, result[:visualization])
    end
    
    if result[:pipeline_config].present?
      CreatePipelineJob.perform_later(message.session.id, result[:pipeline_config])
    end
  end
end

# app/jobs/process_file_upload_job.rb
class ProcessFileUploadJob < ApplicationJob
  queue_as :file_processing
  
  def perform(message_id)
    message = Message.find(message_id)
    return unless message.attachment.present?
    
    # Create data source from uploaded file
    data_source = create_data_source(message)
    
    # Analyze file structure
    analysis = FileAnalyzer.new(TODO: Implement file analysis service).call(data_source)
    
    # Create AI response message
    Message.create!(
      session: message.session,
      user: message.user,
      role: :assistant,
      content: "I've analyzed your file. #{analysis[:summary]}. What would you like to do with this data?",
      metadata: {
        file_analysis: analysis
      }
    )
  end
  
  private
  
  def create_data_source(message)
    DataSource.create (
      session: message.session,
      name: message.attachment.filename.to_s,
      file_type: message.attachment.content_type,
      file_size: message.attachment.byte_size,
      file_path: message.attachment.service_url
    )
  end
end

# app/jobs/generate_visualization_job.rb
class GenerateVisualizationJob < ApplicationJob
  queue_as :visualization
  
  def perform(message_id, visualization_data)
    message = Message.find(message_id)
    visualization = Visualization.create!(
      session: message.session,
      type: visualization_data[:type],
      data: visualization_data[:data],
      options: visualization_data[:options]
    )
    
    # Update message with visualization reference
    message.update!(visualization: visualization)
  end
end

---

6. Controllers & Routes
Application Controller Setup
ruby# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_current_session
  
  private
  
  def set_current_session
    return unless user_signed_in?
    
    session_id = cookies.signed[:session_id]
    @current_session = current_user.sessions.find_by(session_id: session_id)
    
    if @current_session.nil?
      @current_session = current_user.sessions.create!
      cookies.signed[:session_id] = {
        value: @current_session.session_id,
        expires: 30.days.from_now
      }
    end
  end
end

# app/controllers/home_controller.rb
class HomeController < ApplicationController
  def index
    @messages = @current_session.messages.includes(:user, :rich_text_content)
                                         .conversation_order
  end
end

# app/controllers/messages_controller.rb
class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :update, :destroy]
  
  def create
    @message = @current_session.messages.build(message_params)
    @message.user = current_user
    
    if @message.save
      process_message
      respond_to do |format|
        format.turbo_stream
        format.json { render json: @message, status: :created }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace('new_message', partial: 'messages/form', locals: { message: @message }) }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def show
    respond_to do |format|
      format.html
      format.json { render json: @message }
    end
  end
  
  def update
    if @message.update(message_params)
      respond_to do |format|
        format.turbo_stream
        format.json { render json: @message }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@message, partial: 'messages/form', locals: { message: @message }) }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @message.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@message) }
      format.json { head :no_content }
    end
  end
  
  private
  
  def set_message
    @message = @current_session.messages.find(params[:id])
  end
  
  def message_params
    params.require(:message).permit(:content, :attachment)
  end
  
  def process_message
    if @message.attachment.present?
      ProcessFileUploadJob.perform_later(@message.id)
    else
      ProcessAiQueryJob.perform_later(@message.id)
    end
  end
end

# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  before_action :set_session, only: [:show, :update, :destroy]
  
  def index
    @sessions = current_user.sessions.order(created_at: :desc)
  end
  
  def show
    @messages = @session.messages.includes(:user, :rich_text_content)
                                 .conversation_order
  end
  
  def create
    @session = current_user.sessions.build(session_params)
    
    if @session.save
      cookies.signed[:session_id] = @session.session_id
      redirect_to @session
    else
      render :new
    end
  end
  
  def update
    if @session.update(session_params)
      redirect_to @session
    else
      render :edit
    end
  end
  
  def destroy
    @session.destroy
    redirect_to sessions_path
  end
  
  def switch
    @session = current_user.sessions.find_by(session_id: params[:session_id])
    if @session
      cookies.signed[:session_id] = @session.session_id
      redirect_to root_path
    else
      redirect_to sessions_path, alert: "Session not found"
    end
  end
  
  private
  
  def set_session
    @session = current_user.sessions.find(params[:id])
  end
  
  def session_params
    params.require(:session).permit(:title)
  end
end

# app/controllers/pipelines_controller.rb
class PipelinesController < ApplicationController
  before_action :set_pipeline, only: [:show, :edit, :update, :destroy, :execute]
  
  def index
    @pipelines = current_user.pipelines.includes(:pipeline_steps, :data_sources)
  end
  
  def show
    @pipeline_runs = @pipeline.pipeline_runs.order(created_at: :desc).limit(10)
  end
  
  def new
    @pipeline = current_user.pipelines.build
  end
  
  def create
    @pipeline = current_user.pipelines.build(pipeline_params)
    
    if @pipeline.save
      redirect_to @pipeline, notice: 'Pipeline was successfully created.'
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @pipeline.update(pipeline_params)
      redirect_to @pipeline, notice: 'Pipeline was successfully updated.'
    else
      render :edit
    end
  end
  
  def destroy
    @pipeline.destroy
    redirect_to pipelines_path, notice: 'Pipeline was successfully destroyed.'
  end
  
  def execute
    pipeline_run = @pipeline.pipeline_runs.create!(
      session: @current_session,
      status: :queued
    )
    
    ExecutePipelineJob.perform_later(pipeline_run.id)
    
    respond_to do |format|
      format.html { redirect_to @pipeline, notice: 'Pipeline execution started.' }
      format.json { render json: pipeline_run }
    end
  end
  
  private
  
  def set_pipeline
    @pipeline = current_user.pipelines.find(params[:id])
  end
  
  def pipeline_params
    params.require(:pipeline).permit(:name, :description, :status, 
                                     configuration: {}, 
                                     data_source_ids: [],
                                     pipeline_steps_attributes: [:id, :name, :description, :step_type, :position, :_destroy, configuration: {}])
  end
end

# app/controllers/data_sources_controller.rb
class DataSourcesController < ApplicationController
  before_action :set_data_source, only: [:show, :edit, :update, :destroy, :preview]
  
  def index
    @data_sources = current_user.data_sources.includes(:file_attachment)
  end
  
  def show
    @sample_data = load_sample_data
  end
  
  def new
    @data_source = current_user.data_sources.build
  end
  
  def create
    @data_source = current_user.data_sources.build(data_source_params)
    
    if @data_source.save
      AnalyzeDataSourceJob.perform_later(@data_source.id)
      redirect_to @data_source, notice: 'Data source was successfully created.'
    else
      render :new
    end
  end
  
  def update
    if @data_source.update(data_source_params)
      redirect_to @data_source, notice: 'Data source was successfully updated.'
    else
      render :edit
    end
  end
  
  def destroy
    @data_source.destroy
    redirect_to data_sources_path, notice: 'Data source was successfully destroyed.'
  end
  
  def preview
    @data = DataLoader.new(@data_source.file).load.first(100)
    
    respond_to do |format|
      format.html
      format.json { render json: @data }
    end
  end
  
  private
  
  def set_data_source
    @data_source = current_user.data_sources.find(params[:id])
  end
  
  def data_source_params
    params.require(:data_source).permit(:name, :description, :source_type, :file, configuration: {})
  end
  
  def load_sample_data
    return [] unless @data_source.file.attached?
    DataLoader.new(@data_source.file).load.first(10)
  rescue StandardError => e
    Rails.logger.error "Failed to load sample data: #{e.message}"
    []
  end
end

# app/controllers/api/v1/base_controller.rb
module Api
  module V1
    class BaseController < ActionController::API
      before_action :authenticate_api_user!
      
      private
      
      def authenticate_api_user!
        token = request.headers['Authorization']&.split(' ')&.last
        @current_user = User.find_by(api_token: token)
        
        render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
      end
    end
  end
end

# app/controllers/api/v1/messages_controller.rb
module Api
  module V1
    class MessagesController < BaseController
      def create
        session = find_or_create_session
        message = session.messages.build(message_params)
        message.user = @current_user
        
        if message.save
          ProcessAiQueryJob.perform_later(message.id)
          render json: message, status: :created
        else
          render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
        end
      end
      
      private
      
      def find_or_create_session
        session_id = params[:session_id] || SecureRandom.uuid
        @current_user.sessions.find_or_create_by(session_id: session_id)
      end
      
      def message_params
        params.require(:message).permit(:content)
      end
    end
  end
end
Routes Configuration
ruby# config/routes.rb
Rails.application.routes.draw do
  devise_for :users
  
  root 'home#index'
  
  resources :sessions do
    member do
      post :switch
    end
  end
  
  resources :messages, except: [:new, :edit]
  
  resources :pipelines do
    member do
      post :execute
    end
    resources :pipeline_steps, except: [:index]
  end
  
  resources :data_sources do
    member do
      get :preview
    end
  end
  
  namespace :api do
    namespace :v1 do
      resources :messages, only: [:create]
      resources :pipelines, only: [:index, :show, :create, :update]
      resources :data_sources, only: [:index, :show]
    end
  end
  
  mount ActionCable.server => '/cable'
  
  # Sidekiq Web UI (in production, add authentication)
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq' if Rails.env.development?
end

7. Hotwire Frontend Implementation
Stimulus Controllers
javascript// app/javascript/controllers/application.js
import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus = application

export { application }

// app/javascript/controllers/chat_controller.js
import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static targets = ["messages", "input", "form", "fileInput", "fileLabel"]
  static values = { sessionId: String }
  
  connect() {
    this.scrollToBottom()
    this.setupActionCable()
    this.setupKeyboardShortcuts()
  }
  
  disconnect() {
    if (this.channel) {
      this.channel.unsubscribe()
    }
  }
  
  setupActionCable() {
    this.consumer = createConsumer()
    this.channel = this.consumer.subscriptions.create(
      { 
        channel: "ChatChannel", 
        session_id: this.sessionIdValue 
      },
      {
        received: (data) => {
          this.handleReceivedMessage(data)
        }
      }
    )
  }
  
  setupKeyboardShortcuts() {
    document.addEventListener('keydown', (event) => {
      // Cmd/Ctrl + Enter to send message
      if ((event.metaKey || event.ctrlKey) && event.key === 'Enter') {
        event.preventDefault()
        this.sendMessage()
      }
      
      // Escape to clear input
      if (event.key === 'Escape' && document.activeElement === this.inputTarget) {
        this.clearInput()
      }
    })
  }
  
  handleReceivedMessage(data) {
    // Message will be inserted via Turbo Stream
    this.scrollToBottom()
    
    // Handle special message types
    if (data.visualization) {
      this.renderVisualization(data.visualization)
    }
    
    if (data.suggestions) {
      this.updateSuggestions(data.suggestions)
    }
  }
  
  sendMessage(event) {
    if (event) event.preventDefault()
    
    const content = this.inputTarget.value.trim()
    const file = this.fileInputTarget.files[0]
    
    if (!content && !file) return
    
    // Disable form while sending
    this.setFormEnabled(false)
    
    // Submit form via Turbo
    this.formTarget.requestSubmit()
  }
  
  handleFileSelect() {
    const file = this.fileInputTarget.files[0]
    if (file) {
      this.fileLabelTarget.textContent = `Selected: ${file.name}`
      this.fileLabelTarget.classList.add("text-green-600")
    }
  }
  
  clearInput() {
    this.inputTarget.value = ""
    this.fileInputTarget.value = ""
    this.fileLabelTarget.textContent = "Choose file"
    this.fileLabelTarget.classList.remove("text-green-600")
    this.inputTarget.focus()
  }
  
  scrollToBottom() {
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }
  
  setFormEnabled(enabled) {
    this.inputTarget.disabled = !enabled
    this.fileInputTarget.disabled = !enabled
    this.formTarget.querySelectorAll('button').forEach(button => {
      button.disabled = !enabled
    })
  }
  
  renderVisualization(visualizationData) {
    // Implementation for rendering Plotly charts
    const container = document.getElementById(`visualization-${visualizationData.messageId}`)
    if (container && window.Plotly) {
      Plotly.newPlot(container, visualizationData.data, visualizationData.layout)
    }
  }
  
  updateSuggestions(suggestions) {
    const suggestionsContainer = document.getElementById('suggestions')
    if (suggestionsContainer) {
      suggestionsContainer.innerHTML = suggestions.map(suggestion => 
        `<button class="suggestion-chip" data-action="click->chat#useSuggestion" data-suggestion="${suggestion}">
          ${suggestion}
        </button>`
      ).join('')
    }
  }
  
  useSuggestion(event) {
    const suggestion = event.currentTarget.dataset.suggestion
    this.inputTarget.value = suggestion
    this.inputTarget.focus()
  }
}

// app/javascript/controllers/pipeline_builder_controller.js
import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static targets = ["steps", "stepTemplate", "form"]
  
  connect() {
    this.initializeSortable()
  }
  
  initializeSortable() {
    this.sortable = Sortable.create(this.stepsTarget, {
      animation: 150,
      handle: '.drag-handle',
      ghostClass: 'bg-gray-100',
      onEnd: (event) => {
        this.updateStepPositions()
      }
    })
  }
  
  addStep() {
    const template = this.stepTemplateTarget.content.cloneNode(true)
    const stepElement = template.querySelector('.pipeline-step')
    
    // Generate unique ID for new step
    const timestamp = new Date().getTime()
    stepElement.dataset.newRecord = true
    stepElement.querySelectorAll('[name], [id]').forEach(element => {
      if (element.name) {
        element.name = element.name.replace(/\[0\]/, `[${timestamp}]`)
      }
      if (element.id) {
        element.id = element.id.replace(/_0_/, `_${timestamp}_`)
      }
    })
    
    this.stepsTarget.appendChild(stepElement)
    this.updateStepPositions()
  }
  
  removeStep(event) {
    const step = event.target.closest('.pipeline-step')
    
    if (step.dataset.newRecord === 'true') {
      step.remove()
    } else {
      // Mark for destruction
      const destroyInput = step.querySelector('input[name$="[_destroy]"]')
      if (destroyInput) {
        destroyInput.value = '1'
        step.style.display = 'none'
      }
    }
    
    this.updateStepPositions()
  }
  
  updateStepPositions() {
    this.stepsTarget.querySelectorAll('.pipeline-step:not([style*="display: none"])').forEach((step, index) => {
      const positionInput = step.querySelector('input[name$="[position]"]')
      if (positionInput) {
        positionInput.value = index + 1
      }
    })
  }
}

// app/javascript/controllers/data_preview_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["table", "loading", "error"]
  static values = { url: String }
  
  connect() {
    if (this.hasUrlValue) {
      this.loadPreview()
    }
  }
  
  async loadPreview() {
    this.showLoading()
    
    try {
      const response = await fetch(this.urlValue, {
        headers: {
          'Accept': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        }
      })
      
      if (!response.ok) throw new Error('Failed to load preview')
      
      const data = await response.json()
      this.renderTable(data)
    } catch (error) {
      this.showError(error.message)
    }
  }
  
  renderTable(data) {
    if (!data || data.length === 0) {
      this.showError('No data available')
      return
    }
    
    const headers = Object.keys(data[0])
    const headerRow = headers.map(h => `<th class="px-4 py-2 bg-gray-100">${h}</th>`).join('')
    
    const rows = data.map(row => {
      const cells = headers.map(h => `<td class="px-4 py-2 border-t">${row[h] || ''}</td>`).join('')
      return `<tr>${cells}</tr>`
    }).join('')
    
    this.tableTarget.innerHTML = `
      <table class="min-w-full">
        <thead>
          <tr>${headerRow}</tr>
        </thead>
        <tbody>
          ${rows}
        </tbody>
      </table>
    `
    
    this.hideLoading()
  }
  
  showLoading() {
    this.loadingTarget.classList.remove('hidden')
    this.tableTarget.classList.add('hidden')
    this.errorTarget.classList.add('hidden')
  }
  
  hideLoading() {
    this.loadingTarget.classList.add('hidden')
    this.tableTarget.classList.remove('hidden')
  }
  
  showError(message) {
    this.loadingTarget.classList.add('hidden')
    this.tableTarget.classList.add('hidden')
    this.errorTarget.classList.remove('hidden')
    this.errorTarget.textContent = message
  }
}
View Templates
erb<!-- app/views/layouts/application.html.erb -->
<!DOCTYPE html>
<html>
  <head>
    <title>AI ETL Agent</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>
    
    <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
    <%= javascript_include_tag "application", "data-turbo-track": "reload", defer: true %>
    
    <!-- Plotly for visualizations -->
    <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
  </head>

  <body class="bg-gray-50">
    <nav class="bg-white shadow-sm border-b">
      <div class="container mx-auto px-4">
        <div class="flex justify-between items-center h-16">
          <div class="flex items-center">
            <%= link_to "AI ETL Agent", root_path, class: "text-xl font-bold text-gray-800" %>
          </div>
          
          <div class="flex items-center space-x-4">
            <% if user_signed_in? %>
              <%= link_to "Pipelines", pipelines_path, class: "text-gray-700 hover:text-gray-900" %>
              <%= link_to "Data Sources", data_sources_path, class: "text-gray-700 hover:text-gray-900" %>
              <%= link_to "Sessions", sessions_path, class: "text-gray-700 hover:text-gray-900" %>
              
              <div class="relative" data-controller="dropdown">
                <button class="flex items-center text-sm focus:outline-none" data-action="click->dropdown#toggle">
                  <%= current_user.email %>
                  <svg class="ml-2 h-4 w-4" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
                  </svg>
                </button>
                
                <div class="hidden absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg" data-dropdown-target="menu">
                  <%= link_to "Profile", edit_user_registration_path, class: "block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100" %>
                  <%= link_to "API Tokens", "#", class: "block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100" %>
                  <%= link_to "Sign out", destroy_user_session_path, method: :delete, class: "block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100" %>
                </div>
              </div>
            <% else %>
              <%= link_to "Sign in", new_user_session_path, class: "text-gray-700 hover:text-gray-900" %>
              <%= link_to "Sign up", new_user_registration_path, class: "ml-4 px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700" %>
            <% end %>
          </div>
        </div>
      </div>
    </nav>
    
    <main class="container mx-auto px-4 py-8">
      <% if notice.present? %>
        <div class="mb-4 p-4 bg-green-100 border border-green-400 text-green-700 rounded">
          <%= notice %>
        </div>
      <% end %>
      
      <% if alert.present? %>
        <div class="mb-4 p-4 bg-red-100 border border-red-400 text-red-700 rounded">
          <%= alert %>
        </div>
      <% end %>
      
      <%= yield %>
    </main>
  </body>
</html>

<!-- app/views/home/index.html.erb -->
<div class="max-w-4xl mx-auto">
  <div class="bg-white rounded-lg shadow-lg overflow-hidden">
    <div class="border-b px-6 py-4">
      <h1 class="text-2xl font-bold text-gray-800">AI Data Assistant</h1>
      <p class="text-sm text-gray-600 mt-1">Ask questions about your data or create ETL pipelines</p>
    </div>
    
    <div class="flex flex-col h-[600px]" 
         data-controller="chat" 
         data-chat-session-id-value="<%= @current_session.session_id %>">
      
      <!-- Messages Container -->
      <div class="flex-1 overflow-y-auto p-6 space-y-4" data-chat-target="messages" id="messages">
        <%= turbo_frame_tag "messages" do %>
          <%= render @messages %>
        <% end %>
      </div>
      
      <!-- Suggestions -->
      <div id="suggestions" class="px-6 pb-2 flex flex-wrap gap-2">
        <% if @messages.empty? %>
          <button class="suggestion-chip" data-action="click->chat#useSuggestion" data-suggestion="Upload a CSV file">
            Upload a CSV file
          </button>
          <button class="suggestion-chip" data-action="click->chat#useSuggestion" data-suggestion="Show me total sales">
            Show me total sales
          </button>
          <button class="suggestion-chip" data-action="click->chat#useSuggestion" data-suggestion="Create a data pipeline">
            Create a data pipeline
          </button>
        <% end %>
      </div>
      
      <!-- Input Form -->
      <%= form_with model: Message.new, url: messages_path, 
                    data: { 
                      chat_target: "form",
                      action: "turbo:submit-end->chat#clearInput turbo:submit-end->chat#setFormEnabled"
                    },
                    class: "border-t p-4" do |form| %>
        
        <div class="flex items-end space-x-2">
          <div class="flex-1">
            <%= form.text_area :content,
                               placeholder: "Ask about your data...",
                               rows: 1,
                               class: "w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 resize-none",
                               data: { 
                                 chat_target: "input",
                                 action: "keydown.enter->chat#sendMessage"
                               } %>
          </div>
          
          <label class="cursor-pointer bg-gray-100 hover:bg-gray-200 px-4 py-2 rounded-lg transition">
            <span data-chat-target="fileLabel">Choose file</span>
            <%= form.file_field :attachment,
                                class: "hidden",
                                accept: ".csv,.xlsx,.xls,.json",
                                data: { 
                                  chat_target: "fileInput",
                                  action: "change->chat#handleFileSelect"
                                } %>
          </label>
          
          <button type="submit" 
                  class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-2 rounded-lg transition">
            Send
          </button>
        </div>
      <% end %>
    </div>
  </div>
</div>

<style>
  .suggestion-chip {
    @apply px-3 py-1 bg-gray-100 hover:bg-gray-200 rounded-full text-sm text-gray-700 transition cursor-pointer;
  }
</style>

<!-- app/views/messages/_message.html.erb -->
<div id="<%= dom_id(message) %>" class="message <%= message.role %>-message">
  <div class="flex <%= message.user? ? 'justify-end' : 'justify-start' %>">
    <div class="max-w-2xl <%= message.user? ? 'bg-blue-100' : 'bg-gray-100' %> rounded-lg px-4 py-2">
      <div class="flex items-center space-x-2 mb-1">
        <span class="font-semibold text-sm">
          <%= message.user? ? message.user.email : 'AI Assistant' %>
        </span>
        <span class="text-xs text-gray-500">
          <%= message.created_at.strftime("%I:%M %p") %>
        </span>
      </div>
      
      <div class="prose prose-sm max-w-none">
        <%= message.content %>
      </div>
      
      <% if message.attachment.attached? %>
        <div class="mt-2 p-2 bg-white rounded border">
          <div class="flex items-center space-x-2">
            <svg class="w-4 h-4 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13"></path>
            </svg>
            <span class="text-sm text-gray-700"><%= message.attachment.filename %></span>
          </div>
        </div>
      <% end %>
      
      <% if message.metadata['visualization'].present? %>
        <div id="visualization-<%= message.id %>" class="mt-4 h-64"></div>
        <script>
          document.addEventListener('DOMContentLoaded', () => {
            const data = <%= message.metadata['visualization']['data'].to_json.html_safe %>;
            const layout = <%= message.metadata['visualization']['layout'].to_json.html_safe %>;
            Plotly.newPlot('visualization-<%= message.id %>', data, layout);
          });
        </script>
      <% end %>
    </div>
  </div>
</div>

<!-- app/views/pipelines/new.html.erb -->
<div class="max-w-4xl mx-auto">
  <div class="bg-white rounded-lg shadow-lg p-6">
    <h1 class="text-2xl font-bold mb-6">Create New Pipeline</h1>
    
    <%= form_with model: @pipeline, data: { controller: "pipeline-builder" } do |form| %>
      <div class="space-y-6">
        <div>
          <%= form.label :name, class: "block text-sm font-medium text-gray-700" %>
          <%= form.text_field :name, 
                              class: "mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500" %>
        </div>
        
        <div>
          <%= form.label :description, class: "block text-sm font-medium text-gray-700" %>
          <%= form.text_area :description, 
                             rows: 3,
                             class: "mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500" %>
        </div>
        
        <div>
          <div class="flex justify-between items-center mb-4">
            <h3 class="text-lg font-medium">Pipeline Steps</h3>
            <button type="button" 
                    data-action="click->pipeline-builder#addStep"
                    class="px-4 py-2 bg-green-600 text-white rounded-md hover:bg-green-700">
              Add Step
            </button>
          </div>
          
          <div data-pipeline-builder-target="steps" class="space-y-4">
            <%= form.fields_for :pipeline_steps do |step_form| %>
              <%= render 'pipeline_step_fields', form: step_form %>
            <% end %>
          </div>
        </div>
        
        <div>
          <h3 class="text-lg font-medium mb-4">Data Sources</h3>
          <div class="space-y-2">
            <%= form.collection_check_boxes :data_source_ids, 
                                           current_user.data_sources, 
                                           :id, 
                                           :name do |b| %>
              <div class="flex items-center">
                <%= b.check_box class: "rounded border-gray-300 text-blue-600 focus:ring-blue-500" %>
                <%= b.label class: "ml-2 text-sm text-gray-700" %>
              </div>
            <% end %>
          </div>
        </div>
        
        <div class="flex justify-end space-x-4">
          <%= link_to "Cancel", pipelines_path, class: "px-4 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50" %>
          <%= form.submit "Create Pipeline", class: "px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700" %>
        </div>
      </div>
    <% end %>
  </div>
</div>

<!-- Template for new pipeline steps -->
<template data-pipeline-builder-target="stepTemplate">
  <%= fields_for 'pipeline[pipeline_steps_attributes][0]', PipelineStep.new do |step_form| %>
    <%= render 'pipeline_step_fields', form: step_form %>
  <% end %>
</template>

<!-- app/views/pipelines/_pipeline_step_fields.html.erb -->
<div class="pipeline-step bg-gray-50 rounded-lg p-4" data-new-record="<%= form.object.new_record? %>">
  <div class="flex items-start space-x-4">
    <div class="drag-handle cursor-move text-gray-400 hover:text-gray-600">
      <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
      </svg>
    </div>
    
    <div class="flex-1 space-y-4">
      <div class="grid grid-cols-2 gap-4">
        <div>
          <%= form.label :name, class: "block text-sm font-medium text-gray-700" %>
          <%= form.text_field :name, 
                              class: "mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500" %>
        </div>
        
        <div>
          <%= form.label :step_type, class: "block text-sm font-medium text-gray-700" %>
          <%= form.select :step_type, 
                          options_for_select(PipelineStep.step_types.map { |k, v| [k.humanize, k] }),
                          {},
                          class: "mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500" %>
        </div>
      </div>
      
      <div>
        <%= form.label :description, class: "block text-sm font-medium text-gray-700" %>
        <%= form.text_area :description, 
                           rows: 2,
                           class: "mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500" %>
      </div>
      
      <%= form.hidden_field :position %>
      <%= form.hidden_field :_destroy %>
    </div>
    
    <button type="button" 
            data-action="click->pipeline-builder#removeStep"
            class="text-red-600 hover:text-red-800">
      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path>
      </svg>
    </button>
  </div>
</div>

8. Action Cable Integration
Channel Setup
ruby# app/channels/application_cable/connection.rb
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    
    def connect
      self.current_user = find_verified_user
    end
    
    private
    
    def find_verified_user
      if verified_user = env['warden'].user
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end

# app/channels/chat_channel.rb
class ChatChannel < ApplicationCable::Channel
  def subscribed
    session = current_user.sessions.find_by(session_id: params[:session_id])
    if session
      stream_for session
      stream_from "session_#{session.session_id}_messages"
      stream_from "session_#{session.session_id}_visualizations"
    else
      reject
    end
  end
  
  def unsubscribed
    # Cleanup when user disconnects
  end
  
  def typing(data)
    session = current_user.sessions.find_by(session_id: params[:session_id])
    ActionCable.server.broadcast(
      "session_#{session.session_id}_typing",
      {
        user_id: current_user.id,
        typing: data['typing']
      }
    )
  end
end

# app/channels/pipeline_channel.rb
class PipelineChannel < ApplicationCable::Channel
  def subscribed
    pipeline_run = current_user.pipeline_runs.find(params[:pipeline_run_id])
    stream_for pipeline_run
  end
  
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
JavaScript Cable Setup
javascript// app/javascript/channels/consumer.js
import { createConsumer } from "@rails/actioncable"

export default createConsumer()

// app/javascript/channels/pipeline_channel.js
import consumer from "./consumer"

document.addEventListener('turbo:load', () => {
  const pipelineRunElement = document.querySelector('[data-pipeline-run-id]')
  if (!pipelineRunElement) return
  
  const pipelineRunId = pipelineRunElement.dataset.pipelineRunId
  
  consumer.subscriptions.create(
    { 
      channel: "PipelineChannel", 
      pipeline_run_id: pipelineRunId 
    },
    {
      received(data) {
        // Update pipeline run status
        if (data.status) {
          updatePipelineStatus(data.status)
        }
        
        // Append new log entries
        if (data.log) {
          appendLogEntry(data.log)
        }
        
        // Update progress
        if (data.progress) {
          updateProgress(data.progress)
        }
      }
    }
  )
})

function updatePipelineStatus(status) {
  const statusElement = document.getElementById('pipeline-status')
  if (statusElement) {
    statusElement.textContent = status
    statusElement.className = `status-badge status-${status}`
  }
}

function appendLogEntry(log) {
  const logsContainer = document.getElementById('pipeline-logs')
  if (logsContainer) {
    const logEntry = document.createElement('div')
    logEntry.className = `log-entry log-${log.level}`
    logEntry.innerHTML = `
      <span class="log-time">${log.timestamp}</span>
      <span class="log-level">[${log.level.toUpperCase()}]</span>
      <span class="log-message">${log.message}</span>
    `
    logsContainer.appendChild(logEntry)
    logsContainer.scrollTop = logsContainer.scrollHeight
  }
}

function updateProgress(progress) {
  const progressBar = document.getElementById('pipeline-progress')
  if (progressBar) {
    progressBar.style.width = `${progress}%`
    progressBar.textContent = `${progress}%`
  }
}

9. File Upload & Processing
Active Storage Configuration
ruby# config/storage.yml
test:
  service: Disk
  root: <%= Rails.root.join("tmp/storage") %>

local:
  service: Disk
  root: <%= Rails.root.join("storage") %>

amazon:
  service: S3
  access_key_id: <%= ENV['AWS_ACCESS_KEY_ID'] %>
  secret_access_key: <%= ENV['AWS_SECRET_ACCESS_KEY'] %>
  region: <%= ENV['AWS_REGION'] %>
  bucket: <%= ENV['AWS_BUCKET'] %>

# config/environments/development.rb
config.active_storage.variant_processor = :mini_magick
File Analysis Service
ruby# app/services/file_analyzer.rb
class FileAnalyzer < ApplicationService
  attr_reader :data_source
  
  def initialize(data_source)
    @data_source = data_source
  end
  
  def analyze
    return {} unless data_source.file.attached?
    
    case data_source.source_type.to_sym
    when :csv
      analyze_csv
    when :excel
      analyze_excel
    when :json
      analyze_json
    else
      { metadata: {}, configuration: {}, columns: [] }
    end
  end
  
  private
  
  def analyze_csv
    file = download_file
    csv_options = detect_csv_options(file)
    
    data = CSV.read(file.path, **csv_options)
    headers = data.headers || data.first
    
    {
      metadata: {
        row_count: data.size,
        column_count: headers.size,
        file_size: data_source.file.byte_size,
        encoding: csv_options[:encoding]
      },
      configuration: csv_options,
      columns: analyze_columns(data)
    }
  ensure
    file&.close
    file&.unlink
  end
  
  def analyze_excel
    file = download_file
    workbook = Roo::Spreadsheet.open(file.path)
    sheet = workbook.sheet(0)
    
    {
      metadata: {
        row_count: sheet.last_row,
        column_count: sheet.last_column,
        file_size: data_source.file.byte_size,
        sheet_count: workbook.sheets.count,
        sheet_names: workbook.sheets
      },
      configuration: {
        header_row: 1
      },
      columns: analyze_excel_columns(sheet)
    }
  ensure
    file&.close
    file&.unlink
  end
  
  def analyze_json
    content = data_source.file.download
    data = JSON.parse(content)
    
    {
      metadata: {
        record_count: data.is_a?(Array) ? data.size : 1,
        file_size: data_source.file.byte_size,
        structure: detect_json_structure(data)
      },
      configuration: {},
      columns: extract_json_fields(data)
    }
  end
  
  def download_file
    file = Tempfile.new(['analysis', File.extname(data_source.file.filename.to_s)])
    file.binmode
    file.write(data_source.file.download)
    file.rewind
    file
  end
  
  def detect_csv_options(file)
    # Simple CSV option detection
    sample = File.read(file.path, 1000)
    
    delimiter = [',', ';', "\t", '|'].max_by { |d| sample.count(d) }
    has_headers = sample.lines.first.match?(/[a-zA-Z]/)
    
    {
      headers: has_headers,
      col_sep: delimiter,
      encoding: 'UTF-8'
    }
  end
  
  def analyze_columns(data)
    return [] if data.empty?
    
    headers = data.headers || (1..data.first.size).map { |i| "Column #{i}" }
    
    headers.map do |header|
      values = data.map { |row| row[header] }.compact
      
      {
        name: header,
        type: infer_column_type(values),
        nullable: values.size < data.size,
        unique_values: values.uniq.size,
        sample_values: values.first(5)
      }
    end
  end
  
  def analyze_excel_columns(sheet)
    return [] if sheet.last_row.nil?
    
    headers = sheet.row(1)
    columns = []
    
    headers.each_with_index do |header, index|
      col_index = index + 1
      values = (2..sheet.last_row).map { |row| sheet.cell(row, col_index) }.compact
      
      columns << {
        name: header || "Column #{col_index}",
        type: infer_column_type(values),
        nullable: values.size < (sheet.last_row - 1),
        unique_values: values.uniq.size,
        sample_values: values.first(5)
      }
    end
    
    columns
  end
  
  def infer_column_type(values)
    return 'unknown' if values.empty?
    
    # Check if all values are numbers
    if values.all? { |v| v.to_s.match?(/^\d+\.?\d*$/) }
      values.any? { |v| v.to_s.include?('.') } ? 'float' : 'integer'
    # Check if all values are dates
    elsif values.all? { |v| Date.parse(v.to_s) rescue false }
      'date'
    # Check if all values are booleans
    elsif values.all? { |v| ['true', 'false', '1', '0', 'yes', 'no'].include?(v.to_s.downcase) }
      'boolean'
    else
      'string'
    end
  end
  
  def detect_json_structure(data)
    case data
    when Array
      'array'
    when Hash
      'object'
    else
      'primitive'
    end
  end
  
  def extract_json_fields(data, prefix = '')
    fields = []
    
    case data
    when Array
      if data.first.is_a?(Hash)
        extract_json_fields(data.first, prefix)
      else
        fields << { name: prefix || 'value', type: infer_column_type(data) }
      end
    when Hash
      data.each do |key, value|
        field_name = prefix.empty? ? key : "#{prefix}.#{key}"
        
        if value.is_a?(Hash) || value.is_a?(Array)
          fields.concat(extract_json_fields(value, field_name))
        else
          fields << { name: field_name, type: value.class.name.downcase }
        end
      end
    end
    
    fields
  end
end

10. Testing & Running
Development Setup
bash# Install dependencies
bundle install
yarn install

# Setup database
rails db:create
rails db:migrate
rails db:seed

# Start Redis
redis-server

# In separate terminals:
# Start Rails server
rails server

# Start Sidekiq
bundle exec sidekiq

# Start Tailwind CSS watcher
rails tailwindcss:watch

# Optional: Start webpack dev server for JavaScript
./bin/webpack-dev-server
Seed Data
ruby# db/seeds.rb
# Create default user
user = User.create!(
  email: 'demo@example.com',
  password: 'password123',
  confirmed_at: Time.current
)

# Create sample session
session = user.sessions.create!(
  title: 'Demo Session'
)

# Create welcome message
Message.create!(
  session: session,
  user: user,
  role: :assistant,
  content: "Welcome to AI ETL Agent! I can help you analyze data and create ETL pipelines. Try uploading a CSV file or asking me a question about data processing."
)

# Create sample data source
data_source = DataSource.create!(
  user: user,
  name: 'Sample Sales Data',
  source_type: :csv,
  description: 'Sample sales data for demonstration'
)

# Create sample pipeline
pipeline = Pipeline.create!(
  user: user,
  name: 'Sales Data Processing',
  description: 'Process daily sales data and generate reports',
  status: :active
)

# Add pipeline steps
['Extract CSV', 'Validate Data', 'Calculate Metrics', 'Generate Report'].each_with_index do |step_name, index|
  pipeline.pipeline_steps.create!(
    name: step_name,
    position: index + 1,
    step_type: [:extract, :validate, :aggregate, :load][index]
  )
end

puts "Seed data created successfully!"
puts "Login with: demo@example.com / password123"
Running Tests
bash# Setup test database
rails db:test:prepare

# Run all tests
rspec

# Run specific test file
rspec spec/models/message_spec.rb

# Run system tests
rspec spec/system/chat_spec.rb
Example Test Files
ruby# spec/models/message_spec.rb
require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'associations' do
    it { should belong_to(:session) }
    it { should belong_to(:user) }
    it { should have_rich_text(:content) }
    it { should have_one_attached(:attachment) }
  end
  
  describe 'validations' do
    it { should validate_presence_of(:role) }
    it { should validate_presence_of(:content) }
  end
  
  describe 'enums' do
    it { should define_enum_for(:role).with_values(user: 0, assistant: 1, system: 2) }
    it { should define_enum_for(:status).with_values(pending: 0, processing: 1, completed: 2, failed: 3) }
  end
  
  describe '#broadcast_message' do
    let(:message) { create(:message) }
    
    it 'broadcasts to the session channel' do
      expect {
        message.broadcast_message
      }.to have_broadcasted_to("session_#{message.session_id}_messages")
    end
  end
end

# spec/services/ai_service_spec.rb
require 'rails_helper'

RSpec.describe AiService do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }
  let(:message) { create(:message, session: session, user: user, content: 'What are my total sales?') }
  
  describe '.call' do
    subject { described_class.call(message, session) }
    
    context 'with a data query' do
      it 'returns a response with data analysis' do
        expect(subject[:text]).to include('total sales')
        expect(subject[:intent][:type]).to eq(:data_query)
      end
    end
    
    context 'with a greeting' do
      let(:message) { create(:message, content: 'Hello!') }
      
      it 'returns a greeting response' do
        expect(subject[:text]).to include('Hello')
        expect(subject[:intent][:type]).to eq(:greeting)
      end
    end
  end
end

# spec/system/chat_spec.rb
require 'rails_helper'

RSpec.describe 'Chat Interface', type: :system do
  let(:user) { create(:user) }
  
  before do
    sign_in user
  end
  
  scenario 'User sends a message' do
    visit root_path
    
    fill_in 'Ask about your data...', with: 'Hello AI'
    click_button 'Send'
    
    expect(page).to have_content('Hello AI')
    expect(page).to have_content('AI Assistant')
  end
  
  scenario 'User uploads a file' do
    visit root_path
    
    attach_file 'Choose file', Rails.root.join('spec/fixtures/files/sample.csv')
    click_button 'Send'
    
    expect(page).to have_content('sample.csv')
    expect(page).to have_content('successfully processed')
  end
end

11. Production Considerations
Environment Configuration
ruby# config/environments/production.rb
Rails.application.configure do
  # Force SSL
  config.force_ssl = true
  
  # Active Storage
  config.active_storage.variant_processor = :mini_magick
  
  # Action Cable
  config.action_cable.mount_path = '/cable'
  config.action_cable.url = 'wss://your-domain.com/cable'
  config.action_cable.allowed_request_origins = ['https://your-domain.com']
  
  # Active Job
  config.active_job.queue_adapter = :sidekiq
  
  # Cache store
  config.cache_store = :redis_cache_store, {
    url: ENV['REDIS_URL'],
    expires# Compl