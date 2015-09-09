class Api::BubblesController < ApplicationController
  before_action :authenticate

  def index
    @bubbles = Bubble.all
  end

  def show
    @bubble = Bubble.find(params[:id])
  end
end
