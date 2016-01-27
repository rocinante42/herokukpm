class Classroom < ActiveRecord::Base
  belongs_to :school
  belongs_to :classroom_type

  has_many :teachers, class_name: 'User', foreign_key: 'classroom_id'
  has_many :students, class_name: 'Kid', dependent: :destroy
  has_many :bubble_group_statuses
  has_many :bubble_groups, through: :classroom_type

  validates_presence_of :school, :name, :classroom_type
  validates_uniqueness_of :name, scope: :school
  validates :name, length: {maximum: 50 }
  after_create :create_general_bg_statuses

  def class_type
    classroom_type
  end

  def kindergarten?
    classroom_type.type_name.downcase.eql? 'kindergarten'
  end

  def first_grade?
    classroom_type.type_name.downcase.eql? 'first grade'
  end

  def subitize?
    classroom_type.type_name.downcase.eql? 'subitize'
  end
  def create_general_bg_statuses
    BubbleGroup.all.find_each do |bg|
      BubbleGroupStatus.create(bubble_group:bg, classroom:self, active: BubbleGroupStatus::ACTIVE_NONE)
    end
  end
end
