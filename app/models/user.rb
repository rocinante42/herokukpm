class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  attr_accessor :classroom_id
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :role
  belongs_to :school
  has_one :classroom
  has_many :students, through: :classroom, source: :kids
  has_many :schools, -> { uniq }, through: :classrooms
  has_many :family_relationships, dependent: :destroy
  has_many :kids, through: :family_relationships
  #has_many :schools, through: :classrooms

  scope :teachers, ->{ joins(:role).where( roles: { name: "Teacher" })}
  validates_format_of :direct_phone, with: /(\d+-)*\d+/, allow_blank: true

  before_save :assign_role
  after_create :welcome_email
  after_save :welcome_email, :if => :email_changed?

  before_validation on: :create do
    self.password = self.password_confirmation = Devise.friendly_token.first(8)
  end
#when a user signs up, they need to be assigned a role. We can make this default to “Teacher”
  def assign_role
    self.role = Role.find_by name: "Teacher" if self.role.nil?
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

  def welcome_email
    UserMailer.welcome_email(self).deliver
  end
end
