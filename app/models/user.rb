class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :role
  validates_presence_of :first_name, :last_name
  validates_format_of :direct_phone, with: /(\d+-)*\d+/, allow_blank: true

  before_save :assign_role
#when a user signs up, they need to be assigned a role. We can make this default to “Teacher”
  def assign_role
    self.role = Role.find_by name: "Teacher" if self.role.nil?
  end

  def admin?
    self.role.name == "Admin"
  end

  def teacher?
    self.role.name == "Teacher"
  end


end
