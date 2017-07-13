class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:home]
  def home
    @submissions = Field.find_by_sql("SELECT DISTINCT ON (unique_id) unique_id, form_id , updated_at, labelcolor FROM Fields WHERE user_id= #{current_user.id}")
    @labels = Field.where(user_id: current_user.id).where.not(label: nil,label: "" ).pluck(:label,:labelcolor).uniq
  end
end
