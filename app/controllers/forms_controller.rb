require 'securerandom'

class FormsController < ApplicationController

  before_action :set_form, only: [:show, :edit, :update, :destroy]
  layout "formedit", only: [:show]
  before_action :authenticate_user!


  # GET /forms
  # GET /forms.json
  def index
    @submissions = Field.find_by_sql("SELECT DISTINCT ON (unique_id) unique_id, form_id , updated_at FROM Fields WHERE user_id= #{current_user.id}")
  end

  def submitted
    #check again do users has free bonuses?
    bonus = current_user.bonus
    if (bonus>0)
      @found = Payment.where(unique_id: params[:unique_id] ) 
      if (@found.present?) 
        #render text: 'found!'
        flash[:error] = 'Error. This form has been already submitted!'
        redirect_to form_declined_path and return
      end
      #save the payment in the database! 
      @payment = Payment.new()
      @payment.user_id = current_user.id
      @payment.unique_id = params[:unique_id]
      @payment.status = 'submittedforfree'
      @payment.save
      #get one bonus 
      current_user.bonus = bonus-1
      current_user.save
    else
      flash[:error] = 'Some error ocured.'
      redirect_to form_declined_path 
    end
  end

  # GET /forms/1
  # GET /forms/1.json
  def show
    if params.has_key?(:unique_id)
      @editing = true;
      @form = Field.where(unique_id: params[:unique_id]).to_a
      @form_fields = Hash.new
      @form.each do |value|
        @form_fields[value.field_name] = value.field_value
      end
      @form_fields['unique_id'] = params[:unique_id]
      @form_fields['label'] = @form[0]['label']
    else
      @editing = false;
      @form_fields = Hash.new
      @form_fields['unique_id'] = SecureRandom.uuid
    end  
    #get labels 
    @labels = Field.where(user_id: current_user.id).where.not(label: nil,label: "" ).pluck(:label).uniq
    @colors = Field.where(user_id: current_user.id).where.not(label: nil,label: "" ).pluck(:label,:labelcolor).uniq
    @labels.push("other")
    @colors_array = Hash.new
    @colors.each do |color|
        @colors_array[color[0]] = color[1]
    end
    #first calculate how many forms the user already paid 
    @num_already_paid  = Payment.where(user_id: current_user.id).count
    #render text: @num_already_paid and return

    
    case (@form_fields['form_id'])
      when "1042-s"
        @stripe_amount="200"
        @stripe_amount="250" if (@num_already_paid<751)
        @stripe_amount="300" if (@num_already_paid<251)
        @stripe_amount="350" if (@num_already_paid<151)
        @stripe_amount="400" if (@num_already_paid<101)
        @stripe_amount="450" if (@num_already_paid<51)
        @stripe_amount="495" if (@num_already_paid<26)
      when "1097"
        @stripe_amount="100"
        @stripe_amount="150" if (@num_already_paid<751)
        @stripe_amount="200" if (@num_already_paid<251)
        @stripe_amount="250" if (@num_already_paid<151)
        @stripe_amount="300" if (@num_already_paid<101)
        @stripe_amount="350" if (@num_already_paid<51)
        @stripe_amount="395" if (@num_already_paid<26)
      when "1098"
        @stripe_amount="100"
        @stripe_amount="150" if (@num_already_paid<751)
        @stripe_amount="200" if (@num_already_paid<251)
        @stripe_amount="250" if (@num_already_paid<151)
        @stripe_amount="300" if (@num_already_paid<101)
        @stripe_amount="350" if (@num_already_paid<51)
        @stripe_amount="395" if (@num_already_paid<26)
      when "1099a" , "1099b" , "1099c" , "1099cap" , "1099misc" , "1099g" , "1099h" , "1099int" , "1099k" , "1099ltc" , "1099misc" , "1099oid" , "1099patr" , "1099q" , "1099r" , "1099s" , "1099sa" 
        @stripe_amount="100"
        @stripe_amount="125" if (@num_already_paid<751)
        @stripe_amount="150" if (@num_already_paid<251)
        @stripe_amount="175" if (@num_already_paid<151)
        @stripe_amount="200" if (@num_already_paid<101)
        @stripe_amount="250" if (@num_already_paid<51)
        @stripe_amount="295" if (@num_already_paid<26)
      when "3921"
        @stripe_amount="100"
        @stripe_amount="150" if (@num_already_paid<751)
        @stripe_amount="200" if (@num_already_paid<251)
        @stripe_amount="250" if (@num_already_paid<151)
        @stripe_amount="300" if (@num_already_paid<101)
        @stripe_amount="350" if (@num_already_paid<51)
        @stripe_amount="395" if (@num_already_paid<26)
      when "3922"
        @stripe_amount="100"
        @stripe_amount="150" if (@num_already_paid<751)
        @stripe_amount="200" if (@num_already_paid<251)
        @stripe_amount="250" if (@num_already_paid<151)
        @stripe_amount="300" if (@num_already_paid<101)
        @stripe_amount="350" if (@num_already_paid<51)
        @stripe_amount="395" if (@num_already_paid<26)
      when "5498"
        @stripe_amount="100"
        @stripe_amount="150" if (@num_already_paid<751)
        @stripe_amount="200" if (@num_already_paid<251)
        @stripe_amount="250" if (@num_already_paid<151)
        @stripe_amount="300" if (@num_already_paid<101)
        @stripe_amount="350" if (@num_already_paid<51)
        @stripe_amount="395" if (@num_already_paid<26)
      when "8027"
        @stripe_amount="100"
        @stripe_amount="150" if (@num_already_paid<751)
        @stripe_amount="200" if (@num_already_paid<251)
        @stripe_amount="250" if (@num_already_paid<151)
        @stripe_amount="300" if (@num_already_paid<101)
        @stripe_amount="350" if (@num_already_paid<51)
        @stripe_amount="395" if (@num_already_paid<26)
      when "8955SSA"
        @stripe_amount="100"
        @stripe_amount="150" if (@num_already_paid<751)
        @stripe_amount="200" if (@num_already_paid<251)
        @stripe_amount="250" if (@num_already_paid<151)
        @stripe_amount="300" if (@num_already_paid<101)
        @stripe_amount="350" if (@num_already_paid<51)
        @stripe_amount="395" if (@num_already_paid<26)    
      else
        @stripe_amount="395"
    end
    
  end

  # GET /forms/new
  def new
    # @fields = Field.new
    @form_fields = Hash.new
  end

  # GET /forms/1/edit
  def edit
  end

  # GET /forms/1/all
  def all
  end


  # POST /forms
  # POST /forms.json
  def create
    params.each do |key,value|
      if value.present? && !(['unique_id','controller','action','label','label_other','label_color'].include?(key))
        # is this unnecessary ?
        if value.kind_of?(Array)
          value = value[0]
        end 
        found = Field.where(unique_id: params[:unique_id], field_name: key.to_s )
        if found.blank?
          @field = Field.new()
        else
          @field = found.first
        end
        @field.field_name = key.to_s
        @field.field_value = value.to_s
        @field.user_id = current_user.id
        @field.form_id = params[:form_id]
        @field.unique_id = params[:unique_id]
        if params[:label] == 'other'
          @field.label = params[:label_other]
        else 
          @field.label = params[:label]
        end
        @field.labelcolor = params[:label_color]
        @field.save
      end
    end
    @form = Field.where(unique_id: '9fc89d9e-5bcd-4c66-9e60-3ffb93503a88').to_a
    @form_fields = Hash.new
    @form.each do |value|
      @form_fields[value.field_name] = value.field_value
    end
    redirect_to "/"
  end
  # PATCH/PUT /forms/1
  # PATCH/PUT /forms/1.json
  def update
    respond_to do |format|
      if @form.update(form_params)
        format.html { redirect_to @field, notice: 'Form was successfully updated.' }
        format.json { render :show, status: :ok, location: @form }
      else
        format.html { render :edit }
        format.json { render json: @field.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forms/1
  # DELETE /forms/1.json
  def destroy
    Field.where(unique_id: params[:unique_id]).destroy_all
    respond_to do |format|
      format.html { redirect_to '/', notice: 'Form was successfully deleted.' }
    end
  end

  def checkout
     @amount = params[:amount]
  end

  def declined

  end

  def payment
    # Amount in cents
    @amount = params[:amount]
    #render text: params[:unique_id] .inspect
    @found = Payment.where(unique_id: params[:unique_id] ) 
    if (@found.present?) 
      #render text: 'found!'
      flash[:error] = 'Payment canceled.This form has been already paid!'
      redirect_to form_declined_path and return
    end

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Rails Stripe customer',
      :currency    => 'usd'
    )
    #render text: charge.inspect
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to form_declined_path 
    else
    #save the payment in the database! 
    @payment = Payment.new()
    @payment.user_id = current_user.id
    @payment.unique_id = params[:unique_id]
    @payment.status = charge.status
    @payment.save
    #render text: @payment.inspect
   # logger.debug @payment.errors.full_messages
    #end saving in the database
    #
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_form
      #@form = Form.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def form_params
      params.fetch(:form, {})
    end
end
