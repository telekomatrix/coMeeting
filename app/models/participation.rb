class Participation < ActiveRecord::Base
  before_save :create_token
  validates :link, :uniqueness => true

  belongs_to :meeting
  belongs_to :user
  has_many :action_items, :dependent => :destroy

  validates_associated :user
  attr_protected :is_creator, :is_admin
  accepts_nested_attributes_for :action_items, :allow_destroy => true

  def create_token
    self.link ||= SecureRandom.urlsafe_base64(10)
  end
end
