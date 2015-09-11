class Api::PosetsController < ApplicationController
  before_action :authenticate

  def index
    @posets = Poset.all
  end

  def show
    @poset = Poset.find(params[:id])
  end
end
