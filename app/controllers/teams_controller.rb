class TeamsController < ApplicationController

  before_filter :set_section_name

  # GET /teams
  def index
    @teams = Team.all(:order => ['year', 'team_level_id'], :include => [:team_level, :coach])
    year_min = @teams.first.year if @teams.first
    year_max = @teams.last.year  if @teams.last
    if year_min && year_max
      @years = year_min .. year_max
    else
      @years = []
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /teams/1
  def show
    @team = Team.find(params[:id])
    @article = Article.find_all_by_category_id_and_subcategory_id(Article.category_id(:team), @team.id, order: "created_at asc", limit: 20)

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  protected

  def set_section_name
          @top_level_section_name = 'menu.teams'
  end
end
