ActiveAdmin.register User, {:sort_order => "email_asc"} do

  menu :if => proc{ can?(:manage, User) }

  scope :all, default: true
  User::ROLES.each_with_index do |role, index|
    self.send(:scope, role.to_sym) do |users|
      mask = 1 << index
      users.where('roles_mask & ? = ?', mask, mask)
    end
  end

  filter :email

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

  form :partial => "form"

  controller do
    def show
        @user = User.find(params[:id])
        @versions = @user.versions
        @user = @user.versions[params[:version].to_i].reify if params[:version]
        show! #it seems to need this
    end

    def new
      @user = User.new
      @teams = Team.all
      @coaches = Coach.all
      new!
    end

    def edit
      @user = User.find(params[:id])
      @teams = Team.all.map { |team| {id: team.id, name: team.to_team_name_with_coach} }
      @coaches = Coach.all.map { |coach| {id: coach.id, name: coach.name} }
      edit!
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
