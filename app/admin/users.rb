ActiveAdmin.register User, {:sort_order => "email_asc"} do

  menu :if => proc{ can?(:manage, User) }

# TODO: Provide a change password screen

  index do
    column :email
    column :roles do |user|
      user.show_roles
    end
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end

  show do |user|
    attributes_table do
      row :email
      row :roles do
        user.show_roles
      end
    end
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      if f.object.new_record?
        f.input :password
        f.input :password_confirmation
      end
      f.input :roles, :as => :check_boxes, :collection => User::ROLES
    end
    f.buttons
  end

  controller do
    def show
        @user = User.find(params[:id])
        @versions = @user.versions
        @user = @user.versions[params[:version].to_i].reify if params[:version]
        show! #it seems to need this
    end
  end
    sidebar :versions, :partial => "layouts/version", :only => :show

  member_action :history do
    @user = User.find(params[:id])
    @versions = @user.versions
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
