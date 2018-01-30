class CustomizedDevise::RegistrationsController < Devise::RegistrationsController
  protected
    def after_sign_up_path_for(resource_or_scope)
        #ovo rad znaci jednostano nije prenosio params[:referee_code]
    @ref = Referring.where(code: '67').take
   
    if (@ref.present?)

        @email_value= @ref.email 
        refferedUser=User.where(email: @email_value).take 
        if (refferedUser.present?)
            refferedUser.increment!(:bonus)
            @ref.destroy
        end
    end
    super(resource)
  end
end
  