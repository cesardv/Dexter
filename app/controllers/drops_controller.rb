class DropsController < ApplicationController
  before_filter :do_authentication

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

  def destroy
    REDIS.del(params[:id])
    redirect_to root_url
  end


  private

  def do_authentication
    if settings[:private_server]
      authenticate_or_request_with_http_basic do |username, password|
        username == settings[:username] && password == settings[:password]
      end

    end
  end

  def settings
    Rails.application.config.settings
  end

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
