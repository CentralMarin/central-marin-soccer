ActiveAdmin.register Player do


  menu :if => proc{ can?(:manage, Player) }

  controller.authorize_resource

  controller do
    def show
        @player = Player.find(params[:id])
        @versions = @player.versions
        @player = @player.versions[params[:version].to_i].reify if params[:version]
        show! #it seems to need this
    end
  end
    sidebar :versions, :partial => "layouts/version", :only => :show

  member_action :history do
    @player = Player.find(params[:id])
    @versions = @player.versions
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
