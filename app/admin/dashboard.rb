ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do

    columns do
      column do
        panel "Notifications" do
          mg_client = Mailgun::Client.new
          results = mg_client.get "#{Rails.application.secrets.mailgun_domain}/stats"

          render partial: 'notifications', locals: {stats: results.to_h}
        end
      end
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
