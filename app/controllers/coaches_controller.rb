class CoachesController < ApplicationController

  before_filter :set_section_name

  # GET /coaches
  # GET /coaches.json
  def index
    @coaches = Coach.all

    @part_name = 'coaching.overview'
    @web_parts = WebPart.load(@part_name)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /coaches/1
  # GET /coaches/1.json
  def show
    coach = Coach.includes(:teams).find(params[:id])
    json = coach.to_json({:image_url => ActionController::Base.helpers.asset_path(coach.image_url)})

    respond_to do |format|
      format.json {render :json => json}
    end
  end

  protected

  def set_section_name
          @top_level_section_name = 'menu.coaches'
  end
end
