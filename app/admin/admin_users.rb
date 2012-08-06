ActiveAdmin.register AdminUser, {:sort_order => "email_asc"} do

  menu :if => proc{ can?(:manage, AdminUser) }

  controller.authorize_resource

  index do
    column :email
    column :roles do |admin_user|
      admin_user.roles.join(", ").html_safe
    end
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end

  show do |admin_user|
    attributes_table do
      row :email
      row :roles do
        admin_user.roles.join("<br/>").html_safe
      end
    end
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :roles, :as => :check_boxes, :collection => Role.all
    end
    f.buttons
  end

  controller do
    def show
        @admin_user = AdminUser.find(params[:id])
        @versions = @admin_user.versions
        @admin_user = @admin_user.versions[params[:version].to_i].reify if params[:version]
        show! #it seems to need this
    end
  end
    sidebar :versions, :partial => "layouts/version", :only => :show

  member_action :history do
    @admin_user = AdminUser.find(params[:id])
    @versions = @admin_user.versions
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
