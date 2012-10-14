class DispatchesController < ApplicationController
  before_filter :require_current_drop, :only => :show

  def show
    redirect_to current_drop.redirect_url
  end


  private

  def current_drop
    Drop.find_by_id(params[:id])
  end

  def require_current_drop
    render_not_found unless current_drop
  end
end
