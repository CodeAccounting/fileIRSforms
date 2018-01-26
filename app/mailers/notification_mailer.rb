class NotificationMailer < ApplicationMailer
    default from: "from@example.com"
    def referfriend_email(email,code,name,friend_name)
      @code=code
      @name=name
      @friend_name=friend_name
      @domain_name = Rails.application.config.absolute_site_url
      mail(to: email, subject: 'FileIrsForms invitation')
    end
end
