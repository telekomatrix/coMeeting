class Connection < ActiveRecord::Base
  belongs_to :user
  belongs_to :associate, :class_name => 'User'
end
