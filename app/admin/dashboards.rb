ActiveAdmin.register_page "Dashboard" do
  menu :priority => 1, :label => proc { I18n.t("active_admin.dashboard") }

  content :title => proc { I18n.t("active_admin.dashboard") } do
    #div :class => "blank_slate_container", :id => "dashboard_default_message" do
    #  span :class => "blank_slate" do
    #    span I18n.t("active_admin.dashboard_welcome.welcome")
    #    small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #  end
    #end

    section "Recently updated content" do

      if can?(:manage, User)
        # Admin users should see all changes
        versions = Version.where('whodunnit is not null').order('id desc').limit(20)
      else
        # other users should only see their changes
        versions = Version.order('id desc').find_all_by_whodunnit(current_user, :limit => 20)
      end

      table_for versions do
        column "Item" do |v|
          if v.item
            link_to v.item, v.item.admin_permalink
          else
            "<DELETED>"
          end
        end
        #column "Item" do |v| v.item end
        column "Type" do |v| v.item_type.underscore.humanize end
        column "Modified at" do |v| v.created_at.to_s :long end
        column "Admin" do |v|
          case v.whodunnit
            when nil
            when "Unknown user"
              v.whodunnit
            else
              link_to User.find(v.whodunnit), admin_user_path(v.whodunnit)
          end
        end
      end
    end
  end

end



#ActiveAdmin::Dashboards.build do

  # Define your dashboard sections here. Each block will be
  # rendered on the dashboard in the context of the view. So just
  # return the content which you would like to display.
  
  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  #   section "Recent Posts" do
  #     ul do
  #       Post.recent(5).collect do |post|
  #         li link_to(post.title, admin_post_path(post))
  #       end
  #     end
  #   end
  
  # == Render Partial Section
  # The block is rendered within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     div do
  #       render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #     end
  #   end
  
  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.




#  section "Recently updated content" do
#
#    if can?(:manage, User)
#      # Admin users should see all changes
#      versions = Version.where('whodunnit is not null').order('id desc').limit(20)
#    else
#      # other users should only see their changes
#      versions = Version.order('id desc').find_all_by_whodunnit(current_user, :limit => 20)
#    end
#
#    table_for versions do
#      column "Item" do |v|
#        if v.item
#          link_to v.item, v.item.admin_permalink
#        else
#          "<DELETED>"
#        end
#      end
#      #column "Item" do |v| v.item end
#      column "Type" do |v| v.item_type.underscore.humanize end
#      column "Modified at" do |v| v.created_at.to_s :long end
#      column "Admin" do |v|
#        case v.whodunnit
#          when nil
#          when "Unknown user"
#            v.whodunnit
#          else
#            link_to User.find(v.whodunnit), admin_admin_user_path(v.whodunnit)
#        end
#      end
#    end
#  end
#
#end
