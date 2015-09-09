class Api::BubbleGroupsController < Api::ApiController

  def index
    @bubble_groups = BubbleGroup.all
  end

  def show
  	@bubble_group = BubbleGroup.find(params[:id])
  end
end
