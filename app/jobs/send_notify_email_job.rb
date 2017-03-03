class SendNotifyEmailJob < ActiveJob::Base
  queue_as :default

  # def perform(player, content)
  #   PlayerPortalMailer.notify(player, content['subject-en'], content['body-en'], content['subject-es'], content['body-es']).deliver_later
  # end
end
