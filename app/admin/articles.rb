def prepare_article(article_id = nil)

  if article_id.nil?
    @article = Article.new
  else
    @article = Article.find(article_id)
  end

  ADDITIONAL_LOCALES.each do |lang|
    @article.translations.find_or_initialize_by_locale(lang[0])
  end
  @coaches = Coach.all(:order => 'name desc').map {|e| [e.to_s, e.id] }
  @teams = Team.all(:order => 'year desc').map {|e| [e.to_team_name_with_coach, e.id]}

  # Load the all option
  @coaches.insert(0, ['All', 0]);
  @teams.insert(0, ['All', 0]);

end

ActiveAdmin.register Article do

  menu :if => proc{ can?(:manage, Article) }, :label => 'Articles'

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
    column :team_id do |articles|
      Team.to_team_name_with_coach(articles.team_id)
    end
    column :coach_id do |articles|
      Coach.find(articles.coach_id)
    end

    default_actions
  end

  show do
    render 'show'
  end

  collection_action :article_carousel, :title => "Carousel", :method => :get do
    @articles = Article.all
    @articles_in_carousel = ArticleCarousel.all(:joins => :article, :order => "carousel_order asc")

    render "admin/articles/_carousel"
  end

  form :partial => 'form'

  controller do
    cache_sweeper :home_sweeper, :only => [:update_carousel_list]

    def show
        @article = Article.find(params[:id])
        @versions = @article.versions
        @article = @article.versions[params[:version].to_i].reify if params[:version]
        response.headers['X-XSS-Protection'] = "0"
    end

    def new
      prepare_article
      new!
    end

    def edit
      prepare_article params[:id]
      edit!
    end
  end

  sidebar :versions, :partial => "layouts/version", :only => :show

  member_action :history do
    @article = Article.find(params[:id])
    @versions = @article.versions
    render "layouts/history"
  end

  collection_action :update_carousel_list, :method => :get do
    carousel_list = params[:carousel_list]

    # Remove existing carousel items
    ArticleCarousel.all.each do |carousel_item|
      carousel_item.destroy
    end
    #all_carousel_items.destroy_all unless all_carousel_items.nil?

    # Add carousel items
    carousel_list.each_with_index do |article_id, index|
      ac = ArticleCarousel.new()
      ac.article_id = article_id
      ac.carousel_order = index
      ac.save
    end

    head :ok
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
