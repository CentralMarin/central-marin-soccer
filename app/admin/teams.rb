ActiveAdmin.register Team, {:sort_order => "age_asc"} do

 menu if: proc{ can?(:manage, Team) }, :label => 'Teams', :parent => 'Teams'

 index do
    column :age
    column :gender
    column :name
    column(:level, :sortable => :'team_levels.name') {|team| team.team_level.name}
    column(:coach, :sortable => :'coaches.name') {|team| team.coach.to_s}
    default_actions

 end

  show :title => :page_title

 form do |f|
   f.inputs :name => "Team" do
     f.input :coach
     f.input :team_level
     f.input :age
     f.input :gender, :collection => Team::GENDERS
     f.input :name
   end

   f.actions
 end

 controller do
   def show
       @team = Team.find(params[:id])
       @versions = @team.versions
       @team = @team.versions[params[:version].to_i].reify if params[:version]
       show! #it seems to need this
   end
 end
   sidebar :versions, :partial => "layouts/version", :only => :show

 member_action :history do
   @team = Team.find(params[:id])
   @versions = @team.versions
   render "layouts/history"
 end

  # Buttons
  # show this button only at :show action
  action_item :only => :show do
    link_to "History", :action => "history"
  end

  # show this button only at :history action
  action_item :only => :history do
    link_to "Back", :action => "show"
  end
end
