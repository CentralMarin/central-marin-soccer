ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do

    columns do
      column do
        panel 'Revenue' do
          # Determine total
          players = PlayerPortal.all
          by_year = players.group_by {|player| player.birthday.year }

          panel 'Players' do
            table_for by_year.keys do
              column :year
              column :Income do |year|
                # by_year[year].inject(0) {|sum, player| sum + player.amount_paid}
              end
              column :Outstanding do |year|

              end
            end
          end

          events = Event.where(category: Event::categories[:training])
          events.each do |event|
            panel event.title do
              cost = event.cost
              groups = event.event_details.group_by {|detail| "Boys: #{detail.boys_age_groups.to_ranges} Girls: #{detail.girls_age_groups.to_ranges}" }
              table_for groups.keys do
                column :group do |group|
                  group
                end
                column :events do |group|
                  groups[group].length
                end
                column :income do |group|
                  groups[group].inject(0) {|sum, detail| sum + detail.event_registrations.length * cost }
                end
              end
            end
          end
        end
      end
      # column do
      #   panel "Notifications" do
      #     mg_client = Mailgun::Client.new
      #     results = mg_client.get "#{Rails.application.secrets.mailgun_domain}/stats"
      #
      #     render partial: 'notifications', locals: {stats: results.to_h}
      #   end
      # end
    end

    section "Background Jobs" do
      now = Time.now.getgm
      ul do
        li do
          jobs = Delayed::Job.where('failed_at is not null').count(:id)
          link_to "#{jobs} failing jobs", admin_jobs_path(scope: :failing_jobs), style: 'color: red'
        end
        li do
          jobs = Delayed::Job.where('run_at <= ?', now).count(:id)
          link_to "#{jobs} late jobs", admin_jobs_path(scope: :late_jobs), style: 'color: hsl(40, 100%, 40%)'
        end
        li do
          jobs = Delayed::Job.where('run_at > ?', now).count(:id)
          link_to "#{jobs} scheduled jobs", admin_jobs_path(scope: :scheduled_jobs), style: 'color: green'
        end
      end
    end
    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
