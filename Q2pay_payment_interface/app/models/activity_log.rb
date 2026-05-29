class ActivityLog < ApplicationRecord
  belongs_to :user
  belongs_to :loggable, polymorphic: true


def self.create_log(current_user, action, loggable)
  ActivityLog.create!(
    user_id:  current_user.id,
    action: action,
    loggable: loggable
  )

end

end
