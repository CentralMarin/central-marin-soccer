ActiveAdmin.register ArticleCarousel do

  menu :if => proc{ can?(:manage, ArticleCarousel) }, :label => 'Carousel', parent: 'Articles'
end