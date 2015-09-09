class Api::BubbleGroupsController < Api::ApiController
  before_action :authenticate

  def index
    @bubble_groups = BubbleGroup.all
  end

  def show
    @bubble_group = BubbleGroup.find(params[:id])
  end
end
