class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:home]
  def home
    if (params[:label].present?)
        @submissions = Field.find_by_sql("SELECT DISTINCT ON (unique_id) unique_id, form_id , updated_at, labelcolor FROM Fields WHERE user_id= #{current_user.id} AND label='#{params[:label]}'")
        @selected_label = params[:label];
    else
        @submissions = Field.find_by_sql("SELECT DISTINCT ON (unique_id) unique_id, form_id , updated_at, labelcolor FROM Fields WHERE user_id= #{current_user.id}")
        @selected_label = ''
    end
    @labels = Field.where(user_id: current_user.id).where.not(label: nil,label: "" ).pluck(:label,:labelcolor).uniq
    statuses = Payment.where(user_id: current_user.id)
    @statuses_grouped = statuses.group_by(&:unique_id)
  end
  def referfriend

  end
  def sendinviting
    #now send an email with the cusotom register link 
    mail(to: 'dejansabados@yahoo.com', subject: 'Sample Email')
    flash[:notice] = 'Thank you for inviting a friend!'
    redirect_to '/'
  end
end
