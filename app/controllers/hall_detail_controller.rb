class HallDetailController < ApplicationController

  def create
    turkey_death_data = params[:death]
    turkey_hatch_data = params[:hatch]
    @user = User.find(params[:id])
    @user.send_farm_info_email(turkey_death_data, turkey_hatch_data)
    redirect_to @user
  end

end
