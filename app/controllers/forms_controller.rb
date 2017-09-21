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
  end

  def payment
    # Amount in cents
    @amount = 500

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
    #flash.now[:notice] = "Thank you for submitting the form"
    #render :action=>'show'
    rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to form_checkout_path
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
