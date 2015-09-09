class Api::BubblesController < ApplicationController
  def index
    @bubbles = Bubble.all
  end

  def show
    @bubble = Bubble.find(params[:id])
  end
end
