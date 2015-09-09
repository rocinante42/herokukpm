class Api::BubbleStatusesController < Api::ApiController
  def index
    @bubble_statuses = BubbleStatus.all
  end

  def show
    @bubble_status = BubbleStatus.find(params[:id])
  end
end
