class ApplicationController < ActionController::Base
  protect_from_forgery

  def render_not_found(status = :not_found)
    render :text => "Sorry bro, #{status}", :status => status
  end
end
