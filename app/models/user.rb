class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  attr_accessor :classroom_id
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :role
  belongs_to :school
  belongs_to :classroom
  has_many :family_relationships, dependent: :destroy
  has_many :kids, through: :family_relationships
  delegate :students, to: :classroom

  scope :teachers, ->{ joins(:role).where( roles: { name: "Teacher" })}
  validates_format_of :direct_phone, with: /(\d+-)*\d+/, allow_blank: true

  validates_presence_of :classroom, if: :teacher?

  before_save :assign_role, :set_school
  after_create :welcome_email
  after_save :welcome_email, :if => :email_changed?

  before_validation on: :create do
    self.password = self.password_confirmation = Devise.friendly_token.first(8)
  end
#when a user signs up, they need to be assigned a role. We can make this default to “Teacher”
  def assign_role
    self.role = Role.find_by name: "Teacher" if self.role.nil?
    self.school    = nil unless can_have? :school
    self.classroom = nil unless can_have? :classroom
  end

  def full_name
    (first_name || '') + " " + (last_name || '')
  end
  
  def admin?
    self.role.try(:name) == "Admin"
  end

  def teacher?
    self.role.try(:name) == "Teacher"
  end

  def parent?
    self.role.try(:name) == "Parent"
  end

  def teacher_admin?
    self.role.try(:name) == "Teacher Admin"
  end

  def can_have? obj
    case obj.to_s.underscore.to_sym
    when :classroom
      return self.teacher?
    when :school
      return self.teacher? || self.teacher_admin?
    when :role
      true
    else
      false
    end
  end

  def can_change? obj
    case obj.to_s.underscore.to_sym
    when :school
      return self.admin?
    when :classroom, :role
      return self.admin? || self.teacher_admin?
    else
      false
    end
  end

  def welcome_email
    UserMailer.welcome_email(self).deliver
  end

  def set_school
    self.school = self.classroom.school if self.classroom
  end
end
