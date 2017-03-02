
class TeamsController < CmsController

  helper TeamsHelper

  # GET /teams
  def index

    init_web_parts('Teams')

    @top_level_section_name = 'menu.teams'

    @teams = Team.teams()

    respond_to do |format|
      format.html
    end
  end

  # GET /teams/1
  def show
    @team = Team.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
    end
  end
end
