def prepare_article(article_id = nil)

  if article_id.nil?
    @article = Article.new
  else
    @article = Article.find(article_id)
  end

  @coaches = Coach.all.order('name desc').map {|e| [e.to_s, e.id] }
  @teams = Team.all.order('year desc').map {|e| [e.to_team_name_with_coach, e.id]}

  # Load the all option
  @coaches.insert(0, ['All', 0])
  @teams.insert(0, ['All', 0])

end

ActiveAdmin.register Article do

  menu :label => 'Articles'
  permit_params :title, :body, :author, :category_id, :team_id, :coach_id, :published, :crop_x, :crop_y, :crop_w, :crop_h, :article_id, :carousel_order, :image, :translations_attributes => [:title, :body, :locale, :id]

  filter :title
  filter :category
  filter :body
  filter :author
  filter :created_at
  filter :updated_at

  index do
    column :title do |articles|
      articles.translations.where(locale: 'en').title
    end
    column :author
    column 'Has Translation', :sortable => :"article.has_translation()" do |articles|
      articles.has_translation
    end
    column :category do |articles|
      articles.category.to_s
    end
    column :team_id do |articles|
      Team.to_team_name_with_coach(articles.team_id) unless articles.team_id == 0
    end
    column :coach_id do |articles|
      Coach.find(articles.coach_id) unless articles.coach_id == 0
    end

    actions
  end

  show do |article|
    attributes_table do
      row :author
      row :image do
        image_tag image_path(article.image_url)
      end
      row :title do
        show_translated_model_field(article, :title)
      end
      row :body do
        show_translated_model_field(article, :body)
      end
      row :category do
        subcategory = ''
        case article.category
          when :team
            team = Team.find_by id: article.team_id
            if team.blank?
               subcategory = '- Unknown team'
            else
              subcategory = "- #{team.to_s}"
            end
          when :coach
            coach = Coach.where(id: article.coach_id)
            if coach.blank?
              subcategory = '- Unknown coach'
            else
              subcategory = "- #{coach.to_s}"
            end
        end
        "#{article.category} #{subcategory}"
      end
      row :carousel do
        carousel = ArticleCarousel.where(id: article.id)
        if carousel.blank?
          'Not in carousel'
        else
          "At position #{carousel.carousel_order}"
        end
      end
      row :created_at
      row :updated_at
    end
  end

  collection_action :article_carousel, :title => "Carousel", :method => :get do
    @articles = Article.all
    @articles_in_carousel = ArticleCarousel.all.order("carousel_order asc")

    render "admin/articles/_carousel"
  end

  form :html => { :enctype => "multipart/form-data" } do |f|
    prepare_article

    if f.object.errors.size >= 1
      f.inputs "Errors" do
        f.object.errors.full_messages.join('|')
      end
    end

    f.inputs do
      f.translated_inputs "Translated fields", switch_locale: false do |t|
        t.input :title
        t.input :body, :as => :ckeditor, :input_html => {:ckeditor => {:language => "#{t.object.locale}", :scayt_sLang => "#{SPELLCHECK_LANGUAGES[t.object.locale.to_sym]}"}}
      end
    end

    f.inputs do
      f.input :crop_x, :as => :hidden
      f.input :crop_y, :as => :hidden
      f.input :crop_w, :as => :hidden
      f.input :crop_h, :as => :hidden
       f.input :image, :as => :file, :hint => f.object.image.present? \
         ? f.image_tag(f.object.image.url(), :id => "cropbox")
         : f.image_tag("no_image.png", :id => "cropbox")
      f.input :category_id, :collection => Article::ARTICLE_CATEGORY.each_with_index.map {|c, index| [c.to_s, index]}, :as => :select, :label => "Category"
      f.input :team_id, :collection => @teams, :as => :select, :label => "Team", :include_blank => false
      f.input :coach_id, :collection => @coaches, :as => :select, :label => "Coach", :include_blank => false
      f.input :author, :as => :hidden, :input_html => { :value => current_admin_user.email }
    end

    f.actions <<

    "<script>
      function category_changed() {
        switch($('#article_category_id option:selected').text()) {
          case 'team':
            $('#article_team_id_input').show();
            $('#article_coach_id_input').hide();
            break;
          case 'coach':
            $('#article_coach_id_input').show();
            $('#article_team_id_input').hide();
            break;
          default:
            $('#article_team_id_input').hide();
            $('#article_coach_id_input').hide();
        }
      }

      $('#article_category_id').change(category_changed);

      category_changed();

      $(document).ready(soccer.image_crop.init({
        modelName: 'article',
        width: #{Article::IMAGE_WIDTH},
        height: #{Article::IMAGE_HEIGHT}
      }));
     </script>".html_safe
  end

  collection_action :update_carousel_list, :method => :get do
    carousel_list = params[:carousel_list]

    # Remove existing carousel items
    ArticleCarousel.all.each do |carousel_item|
      carousel_item.destroy
    end

    # Add carousel items
    carousel_list.each_with_index do |article_id, index|
      ac = ArticleCarousel.new()
      ac.article_id = article_id
      ac.carousel_order = index
      ac.save
    end

    head :ok
  end

  action_item :only => :index do
    link_to "Carousel", :action => "article_carousel"
  end
end
