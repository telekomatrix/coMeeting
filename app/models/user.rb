class UserValidator < ActiveModel::Validator
  def validate(record)
    if record.email.blank? && record.name.blank?
      record.errors.add(:base, :email_and_name)
    end
  end
end


class User < ActiveRecord::Base
  validates_with UserValidator, :fields => [:email, :name]
  validates :email, :uniqueness => true, :unless => Proc.new { |a| a.email.blank? }

  has_many :participations, :dependent => :destroy
  has_many :meetings, :through => :participations

  has_many :connections, :dependent => :destroy
  has_many :associates, :through => :connections
  
  has_many :inverse_connections, :class_name => "Connection", :foreign_key => 'associate_id', :dependent => :destroy
  has_many :inverse_associates, :through => :inverse_connections, :source => :user

  def circles
    connections | inverse_connections
    # associates | inverse_associates
  end

  def self.find_or_new(email, name)
    if email.blank?
      user = self.new(:name => name)
    else
      user = self.find_by_email(email)
      if user.nil?
        user = self.new(:email => email, :name => name)
      elsif !name.blank?
        user.name = name
      end
    end
    user
  end

  def name_formatted
    if self.name.blank?
      _name = self.email.scan(/^.+(?=@.+)/)[0]
    else
      _name = self.name
    end
    _name
  end

  def name_and_email
    _name = self.name_formatted
    unless self.email.blank?
      _name += " (#{self.email})"
    end
    _name
  end

  def email_address
    address = Mail::Address.new email       # ex: "john@example.com"
    address.display_name = name_formatted   # ex: "John Doe"
    address.format                          # returns "John Doe <john@example.com>"
  end
end