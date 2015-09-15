class Classroom < ActiveRecord::Base
  belongs_to :school
  belongs_to :classroom_type
  belongs_to :teacher, class_name: 'User', foreign_key: 'user_id'
  validates_presence_of :school

  has_many :kids, dependent: :destroy
  has_many :assignments
  has_many :bubble_groups, through: :classroom_type

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
