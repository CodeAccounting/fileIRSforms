class AdminController < ApplicationController
  before_filter :authenticate_user!
  before_filter do 
    redirect_to '/' unless current_user && current_user.admin?
  end
  layout "adminshow", only: [:show]
  def index   
    @submissions = Field.paginate_by_sql("SELECT DISTINCT ON (unique_id) unique_id, form_id , updated_at FROM Fields", page: params[:page], per_page: 10)
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
    path = Rails.public_path.join('export.txt')
    content = "data from the form"
    File.open(path, "w+") do |f|
        f.write(content)
    end
    redirect_to "/admin"
  end
end