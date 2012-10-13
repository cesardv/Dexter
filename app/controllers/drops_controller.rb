class DropsController < ApplicationController
  def new
    @drop = Drop.new
  end
end
