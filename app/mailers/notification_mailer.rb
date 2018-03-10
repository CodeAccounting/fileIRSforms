class NotificationMailer < ApplicationMailer
    default from: "fileirsforms@gmail.com"
    def referfriend_email(email,code,name,friend_name)
      @code=code
      @name=name
      @friend_name=friend_name
      @domain_name = Rails.application.config.absolute_site_url
      mail(to: email, subject: 'FileIrsForms invitation')
    end
    def test_email(email)
      mail(to: email, subject: 'FileIrsForms',from:"fileirsforms@gmail.com")
    end
    def saved_email(email)
      mail(to: email, subject: 'FileIrsForms',from:"fileirsforms@gmail.com")
    end
    def paid_email(email)
      mail(to: email, subject: 'FileIrsForms',from:"fileirsforms@gmail.com")
    end
end
