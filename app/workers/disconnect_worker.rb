class DisconnectWorker
  include Sidekiq::Worker

  def perform(account_id, user_class, user_id)
    return if OnlineStatusTracker.has_user?(account_id, user_class, user_id)

    user = user_class.constantize.find_by(id: user_id)
    return unless user

    user.update(availability_status: 'offline') if user.respond_to?(:availability_status)
  end
end
