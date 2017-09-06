module AdminHelper
    def addT(data)
  end
end
=begin
module UsersHelper
  def full_name(user)
    user.first_name + user.last_name
  end
end

class UsersController < ApplicationController

  def update
    @user = User.find params[:id]
    if @user.update_attributes(user_params)
      notice = "#{helpers.full_name(@user) is successfully updated}"
      redirect_to user_path(@user), notice: notice
    else
      render :edit
    end
  end
end
=end