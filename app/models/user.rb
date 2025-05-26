class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :projects, dependent: :destroy
  has_many :pipelines, through: :projects
  has_many :audit_logs, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :ai_interaction_logs, dependent: :destroy
  has_many :dashboards, dependent: :destroy

  # Validations
  validates :first_name, :last_name, presence: true
  validates :role, inclusion: { in: %w[admin user viewer] }

  # Enums
  enum :role, { viewer: 0, user: 1, admin: 2 }

  # Callbacks
  before_validation :set_default_role, on: :create

  # Instance methods
  def full_name
    "#{first_name} #{last_name}".strip
  end

  def display_name
    full_name.present? ? full_name : email
  end

  def can_manage?(resource)
    case resource.class.name
    when 'Project'
      admin? || resource.user_id == id
    when 'Pipeline'
      admin? || resource.project.user_id == id
    when 'SystemSetting'
      admin?
    else
      admin? || user?
    end
  end

  def can_view?(resource)
    can_manage?(resource) || viewer?
  end

  private

  def set_default_role
    self.role ||= 'user'
  end
end
