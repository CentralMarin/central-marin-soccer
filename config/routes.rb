Rails.application.routes.draw do

  root :to => 'home#index'

  mount Ckeditor::Engine => '/admin/ckeditor'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  get '/tryouts', :to => 'tryouts#index', :as => 'tryouts'

  get '/tryouts/registration', :to => 'tryouts#registration', :as => 'tryouts_registration'
  post '/tryouts/registration', :to => 'tryouts#registration_create', :as => 'tryouts_registration_create'
  get '/tryouts/agegroupchart', :to => 'tryouts#agegroupchart', :as => 'tryouts_agegroupchart'
  get '/tryouts/agelevel', :to => 'tryouts#agelevel', :as => 'tryouts_agelevel'


  get '/portal/:uid/clubform', :to => 'player_portals#club_form', :as => 'player_portal_club_form'
  get '/portal/:uid/login', :to => 'player_portals#session_new', :as => 'player_portal_login'
  post '/portal/:uid/login', :to => 'player_portals#session_create', :as => 'player_portal_create'
  get '/portal/:uid/logout', :to => 'player_portals#session_destroy', :as => 'player_portal_logout'
  get '/portal/:uid', :to => 'player_portals#index', :as => 'player_portal'

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

  get '/referees', to: 'information#referees', as: 'referees'
  get '/referees/2-man-ref-system', to: redirect('/referees')
  get '/tournaments', to: 'information#tournaments', as: 'tournaments'
  get '/field-setup', to: 'information#field_setup'

  post '/web_part/save', to: 'web_part#update', as: 'update_web_part'
  post '/web_part/translate', to: 'web_part#translate', as: 'translate_content'
  get '/web_part/:locale', to: 'web_part#show', as: 'web_part'
end
