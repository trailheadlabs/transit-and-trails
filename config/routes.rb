Transitandtrails::Application.routes.draw do

  class SslConstraint 
    def self.matches?(request) 
      !Rails.env.production? || request.ssl?
    end 
  end
  
  constraints SslConstraint do
    constraints :subdomain => (Rails.env.production? ? /api\.rails|api/ : /.*/) do
      namespace :api, :defaults => {:format => :json} do
        namespace :v1 do
          resources :users, :only => [:show, :index]
          resources :attribute_categories, :only => [:show, :index]
          resources :trailheads, :only => [:show, :index] do
            member do
              get 'photos'
              get 'attributes'
              get 'maps'
            end
          end
          resources :campgrounds, :only => [:show, :index] do
            member do
              get 'photos'
              get 'attributes'
              get 'maps'
            end
          end
          resources :trips, :only => [:show, :index] do
            member do
              get 'photos'
              get 'attributes'
              get 'maps'
              get 'route'
            end
          end
          resources :trailhead_attributes, :only => [:show, :index]
        end
      end
    end
  end

  constraints :subdomain => (Rails.env.production? ? /embed\.rails|embed|rails/ : /.*/) do
    namespace :embed do      
      match "login" => "sessions#new", :as => :sigin
      match "signin" => "sessions#new"
      match "signout" => "sessions#destroy", :as => :signout
      match "signup" => "registrations#new", :as => :signup
      match "confirm" => "registrations#confirm", :as => :confirm
      match "approve" => "registrations#approve", :as => :approve
      resources :trailheads do
        member do
          get 'details'
        end
      end
      resources :sessions, :only => [:new]
      resources :registrations, :only => [:new,:create]
      resources :trips, :only => [:new,:create,:update,:edit] do
        member do
          get 'edit_details'
          get 'edit_photos'
          put 'update_details'
          put 'update_photos'
        end
      end
      match "plan/location" => "plan#location"
      match "plan/trailhead/:trailhead_id" => "plan#trailhead"
      match "plan/campground/:campground_id" => "plan#campground"
      match "plan/trip/:trip_id" => "plan#trip"
      match "plan/trailhead_list" => "plan#trailhead_list"
      match "plan/non_profit_partner_trailheads" => "plan#non_profit_partner_trailheads"
    end
  end

  resources :trips do
    resources :maps
    resources :photos
    resources :stories
    collection do
      get 'near_address'
      get 'near_coordinates'
    end
    member do
      get 'info_window'
    end
  end

  resources :campgrounds do
    resources :maps
    resources :photos
    resources :stories
    collection do
      get 'near_address'
      get 'near_coordinates'
    end
    member do
      get 'info_window'
    end
  end

  resources :trailheads do
    resources :maps
    resources :photos
    resources :stories
    collection do
      get 'near_address'
      get 'near_coordinates'
      get 'within_bounds'
    end
    member do
      get 'info_window'
      get 'trip_editor_info_window'
      get 'transit_routers'
    end
  end

  match 'parks(/:slug(/:county_slug))' => "parks#show"

  resources :parks do 
    resources :maps, :only => [:index]
    resources :photos, :only => [:index]
    resources :trailheads, :only => [:index]
    resources :campgrounds, :only => [:index]
  end

  resources :stories

  resources :parks, :only => [:show]

  resources :partners, :only => [:index]

  match 'profile' => 'user_profiles#edit', :as => :profile

  resources :user_profiles do
    member do
      post 'reset_api_key'
    end
  end



  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :users

  root :to => "find#find"

  match 'objects/near/html' => 'find#objects_near'

  match 'find' => "find#find"

  match 'marinstage' => "find#marinstage"

  match 'find/marinstage' => "find#marinstage"

  match 'find/sanjosetrails' => "find#sanjosetrails"

  match 'find(/:region)' => "find#regional_landing_page"

  match '/:id' => 'high_voltage/pages#show', :as => :static, :via => :get

  match 'geo/coordinates' => "geo#coordinates"

  match 'geo/distance_between' => "geo#distance_between"

  match 'session/loadkv' => "application#loadkv"
  match 'session/savekv' => "application#savekv"

  match 'plan/trailhead/:trailhead_id' => "plan#trailhead"
  match 'plan/trip/:trip_id' => "plan#trip"
  match 'plan/campground/:campground_id' => "plan#campground"

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
