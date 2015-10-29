class HasClassroomValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[:base] << "Kid must have a classroom" if record.classroom.blank?
  end
end

class Kid < ActiveRecord::Base
  belongs_to :classroom

  has_many :bubble_group_statuses, dependent: :destroy
  has_many :bubble_statuses, through: :bubble_group_statuses
  has_many :bubble_groups, through: :bubble_group_statuses
  has_many :kid_activities, through: :bubble_group_statuses
  has_many :family_relationships, dependent: :destroy
  has_many :parents, through: :family_relationships
  accepts_nested_attributes_for :family_relationships

  validates_presence_of :first_name, :last_name
  validates :classroom, has_classroom: true

  before_create :generate_access_token

  before_create :set_token_expiration_time

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

  def humanize_gender
    case gender
      when 1
        'Male'
      when 2
        'Female'
      else
        ''
    end
  end

  def has_expired_token?
    DateTime.now >= self.token_expiration_time
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

  def recent_play_time
    kid_activities.joins(:assignment).merge(assignments.active).where(updated_at:[7.days.ago..Time.now]).map(&:total_time).inject(:+) || 0
  end
  
  def available_bubble_groups
    active_bubble_groups = bubble_group_statuses.select(&:active?).map(&:bubble_group).uniq
    #bubble_group_statuses.active.any? ? BubbleGroup.joins(:bubble_group_statuses).merge(bubble_group_statuses.active).uniq : classroom.bubble_groups
    active_bubble_groups.any? ? active_bubble_groups : classroom.bubble_groups
  end

  def generate_access_token
    begin
      self.access_token = classroom.school.name.split.join + rand(1000..9999).to_s
    end while self.class.exists?(access_token: access_token)
  end

  def as_json(options={})
    {id: self.id, first_name: self.first_name, last_name: self.last_name}
  end

  private

  def set_token_expiration_time
    self.token_expiration_time = DateTime.now + 5.minutes
  end
end
