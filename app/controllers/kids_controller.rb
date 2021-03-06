class KidsController < ApplicationController
  before_action :authenticate_user!
  before_action :prepare_reports_data, only: [:reports, :download_report]
  before_action :set_available_values_for_kid, only: [:new, :edit]
  before_action :update_kid_token_expiration_time, only: [:play, :play_game, :games, :result]
  load_and_authorize_resource
  skip_before_filter :verify_authenticity_token, :only => [:result]

  # GET /kids
  # GET /kids.json
  def index
    @classroom_hash = {}
    @page = params[:page] || 1
    @schools = School.all
    if params.has_key? :classroom
      @current_classroom = Classroom.find(params[:classroom])
      @current_school = @current_classroom.school
    else
      @current_school = School.joins(:classrooms).sample
      @current_classroom = @current_school.classrooms.sample
    end
    @schools.each do |school|
      @classroom_hash[school.id] = school.classrooms.pluck(:id, :name)
    end
    @kids = @current_classroom.students.paginate(page: @page, per_page: 10)
  end

  # GET /kids/1
  # GET /kids/1.json
  def show
  end

  # GET /kids/new
  def new
    @kid = Kid.new
    @kid.classroom = Classroom.find(params[:classroom]) if params.has_key? :classroom
    2.times{@kid.family_relationships.build.build_parent}
  end

  # GET /kids/1/edit
  def edit
    2.times{@kid.family_relationships.build.build_parent}
  end

  ## GET /kids/1/report
  def reports
  end

  def download_report
    pdf = Prawn::Document.new
    pdf.text 'Information', align: :center
    pdf.move_down(20)
    @kid.full_info.each do |k,v|
      pdf.draw_text "#{k}:", at: [150, pdf.y - 30]
      pdf.draw_text "#{v}", at: [350, pdf.y - 30]
      pdf.move_down(20)
    end
    @reports.each do |bg_name, categories|
      pdf.fill_color '000000'
      pdf.text bg_name, align: :center
      pdf.move_down(20)
      categories.each do |category, stats|
        pdf.fill_color '000000'
        pdf.draw_text category, at: [100, pdf.y - 30]
        pdf.fill_color "FFFFFF"
        pdf.stroke_color "00007f"
        full_width = 250
        pdf.fill_and_stroke_rectangle [150, pdf.y - 15], full_width,25
        pdf.fill_color "7589bd"
        pdf.stroke_color "39507d"
        pdf.fill_and_stroke_rectangle [150,pdf.y - 15], full_width * stats[:percent] / 100,25
        pdf.move_down(40)
      end
    end
    send_data pdf.render, :filename => "#{@kid.full_name} Report.pdf", :type => "application/pdf"#, :disposition => 'inline'
  end

  # POST /kids
  # POST /kids.json
  def create
    @kid = Kid.new(kid_params)
    respond_to do |format|
      begin
        if @kid.save
          format.html { redirect_to @kid, notice: 'Kid was successfully created.' }
          format.json { render :show, status: :created, location: @kid }
        else
          set_kid_errors format: format, action: :new
        end
      rescue ActiveRecord::RecordNotUnique
        @kid.errors.add(:base, "Parent's email is already in use")
        set_kid_errors format: format, action: :new
      end
    end
  end

  # PATCH/PUT /kids/1
  # PATCH/PUT /kids/1.json
  def update
    respond_to do |format|
      begin
        if @kid.update(kid_params)
          url = params[:url] || @kid
          if params[:kid] && params[:kid][:classroom_id]
            url = "#{url}?classroom=#{params[:kid][:classroom_id]}"
          end
          format.html { redirect_to url, notice: 'Kid was successfully updated.' }
          format.json { render :show, status: :ok, location: @kid }
        else
          set_kid_errors format: format, action: :edit
        end
      rescue ActiveRecord::RecordNotUnique
        @kid.errors.add(:base, "Parent's email is already in use")
        set_kid_errors format: format, action: :edit
      end
    end
  end

  # DELETE /kids/1
  # DELETE /kids/1.json
  def destroy
    @kid.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Kid was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  ## GET /kids/1/play/
  def play
    if params.has_key? :bubble_group_id
      ## fetch the bubble group
      @bubble_group = BubbleGroup.find(params[:bubble_group_id])

      ## find or create the bubble group status
      @bubble_group_status = @kid.bubble_group_statuses.find_by(bubble_group: @bubble_group)
      unless @bubble_group_status
        @bubble_group_status = @kid.bubble_group_statuses.create(bubble_group: @bubble_group)
      end

      ## handle the result, if present
      if params.has_key?(:result) && params.has_key?(:bubble_status_id)
        ## get bubble status
        bubble_status = BubbleStatus.find(params[:bubble_status_id])
        @bubble_group_status.safe_handle_result! bubble_status, params[:result]
      end

      ## return a randomly sampled active bubble
      @available_bubbles = @bubble_group_status.available_bubbles
      @bubble_status = @available_bubbles.sample
    end
  end

  ## GET /kids/1/play_game/
  def play_game
    ## handle the result, if present
    if params.has_key?(:result) && params.has_key?(:bubble_id)
      ## get the bubble status
      bubble_status = @kid.bubble_statuses.find_by(bubble_id: params[:bubble_id])
      bubble_status.bubble_group_status.safe_handle_result! bubble_status, params[:result]
    end

    ## if a game id was passed in, we want a bubble that supports that game
    if params[:game_id].present?
      @game = Game.find(params[:game_id])
    end

    ## build a bubble group status for each bubble group, if needed, and assemble all of the active bubbles
    available = []
    @kid.available_bubble_groups.each do |bubble_group|
      bubble_group_status = @kid.bubble_group_statuses.find_or_create_by(bubble_group: bubble_group)
      if bubble_group_status.active?
        available += bubble_group_status.available_bubbles
      end
    end

    ## randomly select one of the bubble statuses
    if @game
      ## select a bubble status that supports the selected game
      @bubble_status = available.select{ |bs| bs.bubble.games.include? @game }.sample

      ## get the bubble, and the bubble_game
      if @bubble_status
        @bubble = @bubble_status.bubble
        @bubble_game = @bubble.bubble_games.find_by(game: @game)
      end
    else
      ## select any of the bubble statuses
      @bubble_status = available.select{|bs| bs.bubble.games.count > 0 }.sample

      if @bubble_status
        ## extract the games, sample a game, and get the bubble-game object
        @bubble = @bubble_status.bubble
        @game = @bubble.games.sample
        @bubble_game = @bubble.bubble_games.find_by(game: @game)
      end
    end
  end

  ## GET /kids/1/games
  def games
    ## handle the result, if present
    if params.has_key?(:result) && params.has_key?(:bubble_id)
      bubble_status = @kid.bubble_statuses.find_by(bubble_id: params[:bubble_id])
      bubble_status.bubble_group_status.safe_handle_result! bubble_status, params[:result]
    end

    ## build a bubble group status for each bubble group, if needed, and assemble all of the active bubbles
    available = []
    @kid.available_bubble_groups.each do |bubble_group|
      bubble_group_status = @kid.bubble_group_statuses.find_or_create_by(bubble_group: bubble_group)
      if bubble_group_status.active?
        available += bubble_group_status.available_bubbles
      end
    end

    ## sort info
    @bubble_games = []
    @games_hash = {}
    available.each do |bubble_status|
      bubble_status.bubble.bubble_games.each do |bubble_game|
        arr = @games_hash[bubble_game.game] || []
        arr << bubble_game
        @bubble_games << bubble_game
        @games_hash[bubble_game.game] = arr
      end
    end

    ## filter the results on the game name itself
    if params.has_key? :game_names
      game_names = params[:game_names]
      game_names = [game_names] unless game_names.is_a? Array

      @bubble_games.delete_if{ |bg| !game_names.include? bg.game.name }
      @games_hash.delete_if{ |g, v| !game_names.include? g.name }
    end
  end

  ## POST /kids/1/result
  def result
    success = false
    if params.has_key?(:result) && params.has_key?(:bubble_id)
      ## ensure that the bubble group status exists
      bubble = Bubble.find(params[:bubble_id])
      bubble_group_status = @kid.bubble_group_statuses.find_or_create_by(bubble_group: bubble.bubble_group)

      ## update the bubble status as needed
      bubble_status = @kid.bubble_statuses.find_by(bubble_id: params[:bubble_id])
      bubble_status.bubble_group_status.safe_handle_result! bubble_status, params[:result]
      success = true
    end

    respond_to do |format|
      format.json { render json: {success: success} }
    end
  end

  ## POST /kids/1/reset_access_token
  def reset_access_token
    @kid.generate_access_token
    @kid.save
    redirect_to action: :show, format: :json
  end

  def set_kid_errors format:, action:
    set_available_values_for_kid
    (20 - @kid.parents.count).times{@kid.family_relationships.build.build_parent}
    format.html { render action }
    format.json { render json: @kid.errors, status: :unprocessable_entity }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kid
      @kid = Kid.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def kid_params
      params.require(:kid).permit(:login_id, :classroom_id, :school_id, :first_name, :last_name, :gender, :age, :primary_language, :access_token, family_relationships_attributes:[:id, parent_attributes:[:id, :email, :first_name, :last_name, :password, :role_id]])
    end

    def prepare_reports_data
      set_kid
      @reports = {}
      if params.has_key? :full_report
        @classroom_type = ClassroomType.find_by(type_name: "First grade")
      else
        @classroom_type = @kid.classroom.classroom_type
      end
      @classroom_type.bubble_groups.each do |bg|
        @reports[bg.name] = {}
        (bg.bubble_categories & @classroom_type.bubble_categories).sort_by{|ct| ct.name.split('-').first.to_i}.each do |category|
          total_count = category.bubbles.count
          passed_count = category.bubbles.joins(bubble_statuses: :bubble_group_status).where(bubble_statuses:{passed:true}, bubble_group_statuses:{kid_id:@kid.id}).uniq.count
          @reports[bg.name][category.name] = {
            passed: passed_count,
            total: total_count,
            percent: passed_count.to_f / total_count * 100
          }
        end
      end
    end

    def set_available_values_for_kid
      @genders = {
                   'Choose gender' => nil,
                   'Male'=> 1,
                   'Female'=>2
                 }
      @languages = 
                 {
                    'Choose language' => nil,
                    'Spanish' => 'Spanish',
                    'English' => 'English',
                    'Other' => nil
                 }
      if current_user.admin?
        classrooms = Classroom.all
      elsif current_user.teacher?
        classrooms = Classroom.where(school: current_user.school, id: current_user.classroom)
      else
        classrooms = Classroom.where(school: current_user.school)
      end
      @classrooms = classrooms.pluck(:id, :name)
      @classrooms.unshift([nil, 'Choose Classroom'])
    end

    def update_kid_token_expiration_time
      set_kid
      @kid.update_column(:token_expiration_time, DateTime.now + 5.minutes) if params.has_key?(:result)
    end

end
