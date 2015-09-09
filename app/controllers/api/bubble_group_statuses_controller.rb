class Api::BubbleGroupStatusesController < Api::ApiController
  before_action :authenticate

  def index
    @bubble_group_statuses = BubbleGroupStatus.all
  end

  def show
    @bubble_group_status = BubbleGroupStatus.find(params[:id])
  end
end
