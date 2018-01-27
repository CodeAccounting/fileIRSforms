class CustomizedDevise::RegistrationsController < Devise::RegistrationsController
  protected
    def after_sign_up_path_for(resource_or_scope)
    @ref = Referring.where(code: params[:referee_code]).first
    @email_value= @ref.email
    #render :text => 'works' and return
    refferedUser=User.where(email: @email_value).first 
    refferedUser.increment!(:bonus)
    @ref.destroy
    super(resource)
  end
end
  