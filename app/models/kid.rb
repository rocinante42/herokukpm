class HasClassroomValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[:base] << "Kid must have a classroom" if record.classroom.blank?
  end
end

class Kid < ActiveRecord::Base
  belongs_to :classroom

  has_many :bubble_group_statuses, dependent: :destroy
  has_many :bubble_statuses, through: :bubble_group_statuses
  has_many :assignments
  has_many :bubble_groups, through: :assignments
  has_many :kid_activities, through: :assignments
  has_many :family_relationships, dependent: :destroy
  has_many :parents, through: :family_relationships
  accepts_nested_attributes_for :family_relationships

  validates_presence_of :first_name, :last_name, :gender, :age, :primary_language
  validates :classroom, has_classroom: true

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def kindergarten?
    classroom.kindergarten?
  end

  def first_grade?
    classroom.first_grade?
  end

  def male?
    gender == 1
  end

  def female?
    gender == 2
  end

  def full_info
    {
      'Name' => full_name,
      'Age' => "#{age} years",
      'Language' => primary_language,
      'School' => classroom.school.name,
      'Classroom' => classroom.name,
      'Classroom Type' => classroom.classroom_type.type_name
    }
  end
end
