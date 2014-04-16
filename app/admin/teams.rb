ActiveAdmin.register Team, {:sort_order => "year_desc"} do

 menu :label => 'Teams', :parent => 'Teams'
 permit_params :coach_id, :team_level_id, :gender, :year, :name, :image, :teamsnap_team_id, :crop_x, :crop_y, :crop_w, :crop_h

 index do
    column :year
    column :age, sortable: false
    column :gender
    column :name
    column(:level, :sortable => :'team_levels.name') {|team| team.team_level.name}
    column(:coach, :sortable => :'coaches.name') {|team| team.coach.to_s}
    default_actions

 end

  show :title => :page_title

 form :partial => "form"

 controller do

    def show
       @team = Team.find(params[:id])
       show! #it seems to need this
    end

    def new
      @team = Team.new
      new!
    end

    def edit
      @team = Team.find(params[:id])
      edit!
    end
 end
end
