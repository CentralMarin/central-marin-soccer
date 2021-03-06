
Rails.application.config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
Rails.application.config.assets.precompile += %w(active_admin.css active_admin.js active_admin/active_admin_globalize.css active_admin/active_admin_globalize.js)
Rails.application.config.assets.precompile += %w(jquery.js jquery-1.9.0.js jquery-ui.js) # TODO: Do we really need jquery without a version?
Rails.application.config.assets.precompile += %w(modernizr-2.6.2.min.js)
Rails.application.config.assets.precompile += %w(home.js home.css)
Rails.application.config.assets.precompile += %w(coaches.js coach.css)
Rails.application.config.assets.precompile += %w(fields.js fields.css)
Rails.application.config.assets.precompile += %w(information.css)
Rails.application.config.assets.precompile += %w(email.css)
Rails.application.config.assets.precompile += %w(tryouts.js tryouts.css)
Rails.application.config.assets.precompile += %w(inline_editing.js)
Rails.application.config.assets.precompile += Ckeditor.assets
Rails.application.config.assets.precompile += %w(ckeditor/*)
Rails.application.config.assets.precompile += %w(team.js team.css)
Rails.application.config.assets.precompile += %w(player_portals.js player_portals.css)
Rails.application.config.assets.precompile += %w(jquery.Jcrop.min.css jquery.Jcrop.min.js)