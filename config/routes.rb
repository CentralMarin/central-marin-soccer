Rails.application.routes.draw do

#  resources :tryout_registrations

  root :to => 'home#index'

  mount Ckeditor::Engine => '/admin/ckeditor'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  get '/tryouts', :to => 'tryouts#index', :as => 'tryouts'

  # United Specific Tryouts
  get '/tryouts/united', :to => 'tryouts#united_index', :as => 'tryouts_united_index'
  # get '/tryouts/united/registration', :to => 'tryouts#united_registration', :as => 'tryouts_united_registration'
  # post '/tryouts/united/registration', :to => 'tryouts#united_registration_create', :as => 'tryouts_united_registration_create'


  get '/tryouts/registration', :to => 'tryouts#registration', :as => 'tryouts_registration'
  post '/tryouts/registration', :to => 'tryouts#registration_create', :as => 'tryouts_registration_create'
  get '/tryouts/agegroupchart', :to => 'tryouts#agegroupchart', :as => 'tryouts_agegroupchart'
  get '/tryouts/agelevel', :to => 'tryouts#agelevel', :as => 'tryouts_agelevel'

  get '/news/', :to => 'articles#index', :as => 'articles'
  get '/news/:id', :to => 'articles#show', :as => 'article'

  get '/coaches/', :to => 'coaches#index', :as => 'coaches'
  get '/coaches/:id', :to => 'coaches#show', :as => 'coach'

  get '/teams/', :to => 'teams#index', :as => 'teams'
  get '/teams/:id', :to => 'teams#show', :as => 'team'
  get '/teams/:id/teamsnap', :to => 'teams#teamsnap'

  get '/fields/', :to => 'fields#index', :as => 'fields'
  get '/fields/:id', :to => 'fields#show', :as => 'field'

  get '/contact', to: 'contact#index', as: 'contact'
  get '/calendar', to: 'calendar#index', as: 'calendar'

  get '/information', to: 'information#index', as: 'information'
  get '/information/gold', to: 'information#gold', as: 'gold'
  get '/information/silver', to: 'information#silver', as: 'silver'
  get '/information/academy', to: 'information#academy', as: 'academy'
  get '/information/on-equal-footing', to: 'information#scholarship', as: 'scholarship'
  get '/tournaments/:name/:year', to: 'information#tournaments_previous_winners', as: 'tournaments_previous_winners'

  get '/referees', to: 'information#referees', as: 'referees'
  get '/referees/2-man-ref-system', to: 'information#referees_2_man_ref_system', as: 'referees_2_man_ref_system'
  get '/tournaments', to: 'information#tournaments', as: 'tournaments'

  post '/web_part/save', to: 'web_part#save', as: 'web_part'
end
