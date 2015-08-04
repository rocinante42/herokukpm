class EdgesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  # GET /edges
  # GET /edges.json
  def index
    @edges = Edge.all
  end

  # GET /edges/1
  # GET /edges/1.json
  def show
  end

  # GET /edges/new
  def new
    @edge = Edge.new
  end

  # GET /edges/1/edit
  def edit
  end

  # POST /edges
  # POST /edges.json
  def create
    @edge = Edge.new(edge_params)

    respond_to do |format|
      if @edge.save
        format.html { redirect_to @edge, notice: 'Edge was successfully created.' }
        format.json { render :show, status: :created, location: @edge }
      else
        format.html { render :new }
        format.json { render json: @edge.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /edges/1
  # PATCH/PUT /edges/1.json
  def update
    respond_to do |format|
      if @edge.update(edge_params)
        format.html { redirect_to @edge, notice: 'Edge was successfully updated.' }
        format.json { render :show, status: :ok, location: @edge }
      else
        format.html { render :edit }
        format.json { render json: @edge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /edges/1
  # DELETE /edges/1.json
  def destroy
    @edge.destroy
    respond_to do |format|
      format.html { redirect_to edges_url, notice: 'Edge was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_edge
      @edge = Edge.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def edge_params
      params.require(:edge).permit(:source_id, :destination_id, :poset_id)
    end
end
