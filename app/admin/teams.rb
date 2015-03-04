ActiveAdmin.register Team, {:sort_order => "year_desc"} do

 menu :label => 'Teams', :parent => 'Teams'
 permit_params :coach_id, :team_level_id, :gender, :year, :name, :teamsnap_team_id, :crop_x, :crop_y, :crop_w, :crop_h, :image

 index do
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
   active_admin_comments
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
        width: #{TeamImageUploader::ImageSize::WIDTH},
        height: #{TeamImageUploader::ImageSize::HEIGHT}
      }));
    </script>".html_safe
 end


 csv do
   column :name
   column :team_level
   column :year
   column :gender
   column :coach
   column :teamsnap_team_id
 end

end
