Transitandtrails::Application.routes.draw do
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
    end
    member do
      get 'info_window'
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

  resources :user_profiles

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :users

  root :to => "application#find"

  match 'objects/near/html' => 'application#objects_near'
  match 'find' => "application#index"

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
