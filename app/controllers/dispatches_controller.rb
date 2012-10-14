class DispatchesController < ApplicationController
  before_filter :require_current_drop, :only => :show

  def show
    if current_drop.redirect?
      redirect_to current_drop.redirect_url
    else
      options = {:disposition => 'inline'}

      options.merge!({:type => current_drop.content_type}) if current_drop.content_type
      send_data current_drop.file.read, options
    end
  end


  private

  def current_drop
    Drop.find_by_id(params[:id])
  end

  def require_current_drop
    render_not_found unless current_drop
  end
end
