class Api::BubbleStatusesController < Api::ApiController
  before_action :authenticate

  def index
    @bubble_statuses = BubbleStatus.all
  end

  def show
    @bubble_status = BubbleStatus.find(params[:id])
  end
end
