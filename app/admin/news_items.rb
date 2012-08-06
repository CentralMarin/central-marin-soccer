ActiveAdmin.register NewsItem do

  menu :if => proc{ can?(:manage, NewsItem) }, :label => 'News'

  controller.authorize_resource

  filter :title
  filter :category
  filter :body
  filter :author
  filter :created_at
  filter :updated_at

  index do
    column :title do |news|
      news.translations.find_by_locale('en').title
    end
    column :author
    column 'Has Translation', :sortable => :"news.has_translation()" do |news|
      news.has_translation
    end
    column :carousel
    column :category do |news|
      news.category.to_s
    end
    column :subcategory_id do |news|
      Team.to_team_name_with_coach(news.subcategory_id)
    end

    default_actions
  end

  show do
    render 'show'
  end

  form :partial => 'form'

  controller do
    def show
        @news = NewsItem.find(params[:id])
        @versions = @news.versions
        @news = @news.versions[params[:version].to_i].reify if params[:version]
        show!
    end

    def new
      @news_item = NewsItem.new
      ADDITIONAL_LOCALES.each do |lang|
        @news_item.translations.find_or_initialize_by_locale(lang[0])
      end
      new!
    end

    def edit
      @news_item = NewsItem.find(params[:id])
      ADDITIONAL_LOCALES.each do |lang|
        @news_item.translations.find_or_initialize_by_locale(lang[0])
      end
      edit!
    end
  end

  sidebar :versions, :partial => "layouts/version", :only => :show

  member_action :history do
    @news = NewsItem.find(params[:id])
    @versions = @news.versions
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
