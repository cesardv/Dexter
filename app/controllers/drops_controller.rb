class DropsController < ApplicationController
  def new
    @drop = Drop.new
  end

  def create
    @drop = Drop.create(drop_params)
    if @drop.valid?
      redirect_to drop_path(@drop)
    else
      render :new, :status => :unprocessable_entity
    end
  end


  private
  def drop_params
    params[:drop] || params[:redirect] || params[:file_drop]
  end
end
