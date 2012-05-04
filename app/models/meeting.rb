class Meeting < ActiveRecord::Base
  serialize :topics, Array

  #validates :subject, :presence => true
  #validates :date, :presence => true
  #validates :time, :presence => true
  #validates :time_zone, :presence => true

  has_many :participations, :dependent => :destroy
  has_many :users, :through => :participations

  validates_associated :participations

  def creator
    self.participations.where(:is_creator => true).first.user
  end
end