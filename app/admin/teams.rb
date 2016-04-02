ActiveAdmin.register Team, {:sort_order => "year_desc"} do

  include ActiveAdminCsv

  menu :label => 'Teams', :parent => 'Teams'
  permit_params :coach_id, :team_level_id, :gender, :year, :name, :teamsnap_team_id, :crop_x, :crop_y, :crop_w, :crop_h, :image

  index :download_links => [:csv] do
    column :year
    column :age, sortable: false
    column :gender
    column :name
    column(:level, :sortable => :'team_levels.name') {|team| team.team_level.name}
    column(:coach, :sortable => :'coaches.name') {|team| team.coach.to_s}
    actions

  end

  show do |team|
    attributes_table do
      row :name
      row :team_level
      row :year
      row :gender
      row :image do
        image_tag image_path(team.image_url)
      end
      row :coach
      row :teamsnap_team_id
      row :created_at
      row :updated_at
   end
 end


 form :html => { :enctype => "multipart/form-data" } do |f|
   f.inputs do
     f.input :name
     f.input :team_level
     f.input :year
     f.input :gender
     f.input :coach
     f.input :teamsnap_team_id

     f.input :crop_x, :as => :hidden
     f.input :crop_y, :as => :hidden
     f.input :crop_w, :as => :hidden
     f.input :crop_h, :as => :hidden
     f.input :image, :as => :file, :hint => f.image_tag(f.object.image.url(), :id => "cropbox")
   end
   f.actions     <<

       "<script>
      $(document).ready(soccer.image_crop.init({
        modelName: 'team',
        width: #{Team::IMAGE_WIDTH},
        height: #{Team::IMAGE_HEIGHT}
      }));
    </script>".html_safe
 end

 controller do

   include ActiveAdminCsvController

   def generate_csv(csv, teams)
     csv << ['Name', 'Team Level', 'Year', 'Gender', 'Coach', 'TeamSnap ID']

     teams.each do |team|
       row = []
       row << team.name
       row << team.team_level
       row << team.year
       row << team.gender
       row << team.coach
       row << team.teamsnap_team_id

       csv << row
     end
   end

   def process_csv_row(row, team)


     team = Team.create!(name: row[0],
                  team_level: TeamLevel.includes(:translations).find_by(name: row[1].nil? ? '' : row[1]),
                  year: row[2],
                  gender_id: Gender.id(row[3]),
                  coach: Coach.find_by(name: row[4]),
                  teamsnap_team_id: row[5])

     if team.coach.nil?
       logger.info "Coach: #{row[4]}"
     end

     if team.team_level.nil?
       logger.info "TeamLevel: #{row[1]}"
     end

     team
   end

   def index
     index! do |format|
       format.csv {
         download_csv(Team.all)
       }
     end
   end

 end
end
