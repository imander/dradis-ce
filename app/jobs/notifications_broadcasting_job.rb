class NotificationsBroadcastingJob < ApplicationJob
  queue_as :dradis_project

  def perform(action:, notifiable_id:, notifiable_type:, user_id:)
    notifiable = notifiable_type.constantize.find_by(id: notifiable_id)
    if notifiable.respond_to?(:notify)
      notifiable.notify(action, User.find(user_id))

      notifiable.notifications.each do |notification|
        NotificationsChannel.broadcast_to(notification.recipient, {})
      end
    end
  end
end