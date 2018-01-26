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
    #refering code is the user email
    #now send an email with the cusotom register link 
    NotificationMailer.referfriend_email(params[:email],current_user.email,params[:name],params[:fiend_name]).deliver
    flash[:notice] = 'Thank you for inviting a friend!'
    redirect_to '/'
  end
end
