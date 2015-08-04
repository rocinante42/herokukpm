class BubbleCategoriesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  # GET /bubble_categories
  # GET /bubble_categories.json
  def index
    @bubble_categories = BubbleCategory.all
  end

  # GET /bubble_categories/1
  # GET /bubble_categories/1.json
  def show
  end

  # GET /bubble_categories/new
  def new
    @bubble_category = BubbleCategory.new
  end

  # GET /bubble_categories/1/edit
  def edit
  end

  # POST /bubble_categories
  # POST /bubble_categories.json
  def create
    @bubble_category = BubbleCategory.new(bubble_category_params)

    respond_to do |format|
      if @bubble_category.save
        format.html { redirect_to @bubble_category, notice: 'Bubble category was successfully created.' }
        format.json { render :show, status: :created, location: @bubble_category }
      else
        format.html { render :new }
        format.json { render json: @bubble_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bubble_categories/1
  # PATCH/PUT /bubble_categories/1.json
  def update
    respond_to do |format|
      if @bubble_category.update(bubble_category_params)
        format.html { redirect_to @bubble_category, notice: 'Bubble category was successfully updated.' }
        format.json { render :show, status: :ok, location: @bubble_category }
      else
        format.html { render :edit }
        format.json { render json: @bubble_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bubble_categories/1
  # DELETE /bubble_categories/1.json
  def destroy
    @bubble_category.destroy
    respond_to do |format|
      format.html { redirect_to bubble_categories_url, notice: 'Bubble category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bubble_category
      @bubble_category = BubbleCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bubble_category_params
      params.require(:bubble_category).permit(:name)
    end
end
