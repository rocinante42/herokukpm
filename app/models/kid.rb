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
  validates :age, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 99 }
  validates_presence_of :first_name, :last_name
  validates :classroom, has_classroom: true
  validates :first_name, :last_name,:primary_language, length: { maximum: 25 }
  validates :primary_language, format: { with: /\A[a-zA-Z]+\z/,message: "only allows letters" }
  before_create :generate_access_token

  before_create :set_token_expiration_time
  after_create :create_none_bg_statuses

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
      'Gender' => humanize_gender,
      'Age' => "#{age} years",
      'Language' => primary_language,
      'School' => classroom.school.name,
      'Classroom' => classroom.name,
      'Classroom Type' => classroom.classroom_type.type_name
    }
  end

  def recent_play_time
    kid_activities.joins(:bubble_group_status).merge(bubble_group_statuses.active).where(updated_at:[7.days.ago..Time.now]).map(&:total_time).inject(:+) || 0
  end
  
  def available_bubble_groups
    if bubble_group_statuses.active.any?
      BubbleGroup.joins(:bubble_group_statuses).merge(bubble_group_statuses.active).uniq
    else
      active_bubble_groups = bubble_group_statuses.select(&:active?).map(&:bubble_group).uniq
      active_bubble_groups.any? ? active_bubble_groups : classroom.bubble_groups
    end
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

  def create_none_bg_statuses
    BubbleGroup.all.find_each do |bg|
      general_bg_status = BubbleGroupStatus.where(classroom: classroom, bubble_group:bg).first_or_create
      BubbleGroupStatus.create(kid_id:self.id, classroom: classroom, bubble_group:bg, general_id: general_bg_status.id, active: BubbleGroupStatus::ACTIVE_NONE)
    end
  end
end
