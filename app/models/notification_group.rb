# This class represents the notifications of a user that is grouped under each
# project and on each item. The goal of this class is to provide an easy way
# to group and manage a user's notifications.
class NotificationGroup
  attr_reader :count, :notifications_hash

  def initialize(notifications)
    @grouped_notifications = group_notifications(notifications)
    @count = notifications.count
  end

  def each(&block)
    @grouped_notifications.each(&block)
  end

  def to_h
    @grouped_notifications
  end

  private

  # This method groups the given notifications according to their source item
  # and project.
  # Input: List of notifications
  # Output: Hash with the following format:
  # {
  #   project1 => [
  #     [item1, [notifications]],
  #     [item2, ...]
  #   ],
  #   project2 => ...
  # }
  def group_notifications(notifications)
    # Group each notification using their source item
    hash = notifications.group_by do |n|
      if n.notifiable.is_a?(Comment)
        n.notifiable.commentable
      else
        raise 'Unsupported class!'
      end
    end

    # Group each item using their projects
    hash.group_by { |item, _| item.project }
  end
end
