class Api::PosetsController < ApplicationController
  def index
    @posets = Poset.all
  end

  def show
  	@poset = Poset.find(params[:id])
  end
end
