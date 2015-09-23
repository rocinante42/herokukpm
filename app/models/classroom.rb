class Classroom < ActiveRecord::Base
  belongs_to :school
  belongs_to :classroom_type

  has_many :teachers, class_name: 'User', foreign_key: 'classroom_id'
  has_many :students, class_name: 'Kid', dependent: :destroy
  has_many :assignments
  has_many :bubble_groups, through: :classroom_type

  validates_presence_of :school, :name, :classroom_type
  validates_uniqueness_of :name, scope: :school

  def class_type
    classroom_type
  end

  def kindergarten?
    classroom_type.type_name.downcase.eql? 'kindergarten'
  end

  def first_grade?
    classroom_type.type_name.downcase.eql? 'first grade'
  end
end
