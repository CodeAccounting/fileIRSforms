class AdminController < ApplicationController
  before_filter :authenticate_user!
  before_filter do 
    redirect_to '/' unless current_user && current_user.admin?
  end
  layout "adminshow", only: [:show]
  def index   
    @submissions = Field.paginate_by_sql("SELECT * FROM (SELECT DISTINCT ON (unique_id) unique_id, form_id , updated_at FROM Fields) t ORDER BY updated_at DESC", page: params[:page], per_page: 10)
    #write SQL to retrive status of the submission
    statuses = Payment.all
    @statuses_grouped = statuses.group_by(&:unique_id)
  end
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
      @form_fields = nul
      @form_fields['unique_id'] = nul
    end  
    @labels = Field.where(user_id: current_user.id).where.not(label: nil,label: "" ).pluck(:label).uniq
    @colors = Field.where(user_id: current_user.id).where.not(label: nil,label: "" ).pluck(:label,:labelcolor).uniq
    @labels.push("other")
    @colors_array = Hash.new
    @colors.each do |color|
        @colors_array[color[0]] = color[1]
    end
  end
  def export 
    @form = Field.where(unique_id: params[:unique_id]).to_a
    @form_fields = Hash.new
    @form.each do |value|
        @form_fields[value.field_name] = value.field_value
    end
    #render :text => @form_fields.inspect
    # all alphacharhs should be uppercase except email addresses
    
  #  @form_fields.each{ |s| s.kind_of?(String) ? s.upcase! : s }
  #  @form_fields { |k, v| v.kind_of?(String) ? (@form_fields[k] = v.upcase) : (@form_fields[k] = v)} 
  @form_fields.each { |k, v| @form_fields[k] = v.upcase.to_s } #[0...40]
    case @form_fields['form_id']
      when "3921"
        data = helpers.exportForm3921(@form_fields)
      when "1099A"
        data = helpers.exportForm1099a(@form_fields)
      when "1099B"
        data = helpers.exportForm1099b(@form_fields)
      when "1099C"
        data = helpers.exportForm1099c(@form_fields)
      when "1099CAP"
        data = helpers.exportForm1099cap(@form_fields)
      when "1099DIV"
        data = helpers.exportForm1099div(@form_fields)
      when "1099G"
        data = helpers.exportForm1099g(@form_fields)
      when "1099H"
        data = helpers.exportForm1099h(@form_fields)
      when "1099INT"
        data = helpers.exportForm1099int(@form_fields)
      when "1099K"
        data = helpers.exportForm1099k(@form_fields)
      else
        data = "This form type is not supported yet"
    end
    send_data data,
    :type => 'text/txt; charset=UTF-8;',
    :disposition => "attachment; filename=export.txt" 
  end
end
