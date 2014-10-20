class PosetsController < ApplicationController
  before_action :set_poset, only: [:show, :edit, :update, :destroy]

  # GET /posets
  # GET /posets.json
  def index
    @posets = Poset.all
  end

  # GET /posets/1
  # GET /posets/1.json
  def show
  end

  # GET /posets/new
  def new
    @poset = Poset.new
  end

  # GET /posets/1/edit
  def edit
  end

  # POST /posets
  # POST /posets.json
  def create
    @poset = Poset.new(poset_params)

    respond_to do |format|
      if @poset.save
        format.html { redirect_to @poset, notice: 'Poset was successfully created.' }
        format.json { render :show, status: :created, location: @poset }
      else
        format.html { render :new }
        format.json { render json: @poset.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posets/1
  # PATCH/PUT /posets/1.json
  def update
    respond_to do |format|
      if @poset.update(poset_params)
        format.html { redirect_to @poset, notice: 'Poset was successfully updated.' }
        format.json { render :show, status: :ok, location: @poset }
      else
        format.html { render :edit }
        format.json { render json: @poset.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posets/1
  # DELETE /posets/1.json
  def destroy
    @poset.destroy
    respond_to do |format|
      format.html { redirect_to posets_url, notice: 'Poset was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_poset
      @poset = Poset.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def poset_params
      params.require(:poset).permit(:name)
    end
end
