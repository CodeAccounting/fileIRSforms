class CustomizedDevise::RegistrationsController < Devise::RegistrationsController
  protected
    def after_sign_up_path_for(resource_or_scope)  
    @email_value=Referring.where(code: '7878878').first #params[:referee_code]
    refferedUser=User.where(email: @email_value).first 
    refferedUser.increment!(:bonus)
    super(resource)
  end
end
  
