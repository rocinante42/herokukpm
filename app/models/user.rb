class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :role
  belongs_to :school
  has_many :classrooms
  has_many :students, through: :classrooms, source: :kids
  has_many :schools, -> { uniq }, through: :classrooms
  has_many :family_relationships
  has_many :kids, through: :family_relationships
  scope :teachers, ->{ joins(:role).where( roles: { name: "Teacher" })}
  validates_presence_of :first_name, :last_name
  validates_format_of :direct_phone, with: /(\d+-)*\d+/, allow_blank: true

  before_save :assign_role
  after_create :welcome_email
  after_save :welcome_email, :if => :email_changed?
#when a user signs up, they need to be assigned a role. We can make this default to “Teacher”
  def assign_role
    self.role = Role.find_by name: "Teacher" if self.role.nil?
  end

  def full_name
    first_name + " " + last_name
  end
  
  def admin?
    self.role.name == "Admin"
  end

  def teacher?
    self.role.name == "Teacher"
  end

  def parent?
    self.role.name == "Parent"
  end

  def teacher_admin?
    self.role.name == "Teacher Admin"
  end

  def welcome_email
    UserMailer.welcome_email(self).deliver
  end
end
