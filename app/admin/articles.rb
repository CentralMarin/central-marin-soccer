ActiveAdmin.register Article do

  menu :if => proc{ can?(:manage, Article) }, :label => 'Articles', parent: 'Articles'

  filter :title
  filter :category
  filter :body
  filter :author
  filter :created_at
  filter :updated_at

  index do
    column :title do |articles|
      articles.translations.find_by_locale('en').title
    end
    column :author
    column 'Has Translation', :sortable => :"article.has_translation()" do |articles|
      articles.has_translation
    end
    column :category do |articles|
      articles.category.to_s
    end
    column :subcategory_id do |articles|
      Team.to_team_name_with_coach(articles.subcategory_id)
    end

    default_actions
  end

  show do
    render 'show'
  end

  collection_action :article_carousel, :title => "Carousel", :method => :get do
    @articles = Article.all
    @article_carousel = ArticleCarousel.all

    render "admin/articles/_carousel"
  end

  form :partial => 'form'

  controller do
    def show
        @article = Article.find(params[:id])
        @versions = @article.versions
        @article = @article.versions[params[:version].to_i].reify if params[:version]
        response.headers['X-XSS-Protection'] = "0"
    end

    def new
      @article = Article.new
      ADDITIONAL_LOCALES.each do |lang|
        @article.translations.find_or_initialize_by_locale(lang[0])
      end
      new!
    end

    def edit
      @article = Article.find(params[:id])
      ADDITIONAL_LOCALES.each do |lang|
        @article.translations.find_or_initialize_by_locale(lang[0])
      end
      edit!
    end
  end

  sidebar :versions, :partial => "layouts/version", :only => :show

  member_action :history do
    @article = Article.find(params[:id])
    @versions = @article.versions
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

  action_item :only => :index do
    link_to "Carousel", :action => "article_carousel"
  end
end
