class DropsController < ApplicationController
  before_filter :require_current_drop, :only => :show
  def new
    @drop = Drop.new
  end

  def create
    @drop = Drop.create(drop_params)
    if @drop.valid?
      if params["js-upload"] 
        render :json => {:url => drop_url(@drop)}
      else
        redirect_to drop_path(@drop)
      end
    else
      if params['js-upload']
        render :json => {:errors => @drop.errors}, :status => :unprocessable_entity
      else
        render :new, :status => :unprocessable_entity
      end
    end
  end

  def show
  end


  private

  def require_current_drop
    render_not_found unless current_drop
  end

  helper_method :current_drop
  def current_drop
    @current_drop ||= Drop.find_by_id(params[:id])
  end

  def drop_params
    params[:drop] || params[:redirect] || params[:file_drop]
  end
end
