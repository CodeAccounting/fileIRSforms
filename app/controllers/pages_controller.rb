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
  end
end
