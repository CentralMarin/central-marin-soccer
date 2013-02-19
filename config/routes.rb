CentralMarin::Application.routes.draw do

  # Single page
  root :to => 'home#index'

  # Active Admin
  mount Ckeditor::Engine => '/admin/ckeditor'
  ActiveAdmin.routes(self)
  devise_for :users, ActiveAdmin::Devise.config

  match '/news/', :to => 'articles#index', :as => 'articles'
  match '/news/:id', :to => 'articles#show', :as => 'article'

  match '/coaches/', :to => 'coaches#index', :as => 'coaches'
  match '/coaches/:id', :to => 'coaches#show', :as => 'coach'

  match '/teams/', :to => 'teams#index', :as => 'teams'
  match '/teams/:id', :to => 'teams#show', :as => 'team'
  match '/teams/:id/roster', :to => 'teams#roster', :as => 'roster'
  match '/teams/:id/schedule', :to => 'teams#schedule', :as => 'schedule'
  match '/teams/:id/record', :to => 'teams#record', :as => 'record'

  match '/fields/', :to => 'fields#index', :as => 'fields'
  match '/fields/:id', :to => 'fields#show', :as => 'field'

  match '/contact', to: 'contact#index', as: 'contact'
  match '/calendar', to: 'calendar#index', as: 'calendar'

  match '/information', to: 'information#index', as: 'information'
  match '/information/gold', to: 'information#gold', as: 'gold'
  match '/information/silver', to: 'information#silver', as: 'silver'
  match '/information/academy', to: 'information#academy', as: 'academy'
  match '/information/on-equal-footing', to: 'information#scholarship', as: 'scholarship'

  match '/referees', to: 'information#referees', as: 'referees'
  match '/tournaments', to: 'information#tournaments', as: 'tournaments'

  match '/web_part/save', to: 'web_part#save', as: 'web_part'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
