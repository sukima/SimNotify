ActionController::Routing::Routes.draw do |map|
  map.resources :location_suggestions, :member => { :delete => :get }

  map.resources :manikins, :member => { :delete => :get }

  map.resources :scenarios, :member => { :delete => :get }

  # shallow nested resource trick found from:
  # http://weblog.jamisbuck.org/2007/2/5/nesting-resources
  map.resources :events, :has_many => :scenarios,
  :collection => {
    :approve_all => :put
  },
  :member => {
    :delete => :get,
    :submit => :get,
    :revoke => :get,
    :approve => :put
  } do |m|
    m.resources :assets, :name_prefix => "event_", :member => { :delete => :get }
  end

  #map.resources :assets, :only => :index, :member => { :delete => :get }

  map.resources :special_events, :member => { :delete => :get }

  map.signup 'signup', :controller => 'instructors', :action => 'new'
  map.logout 'logout', :controller => 'instructor_sessions', :action => 'destroy'
  map.login 'login', :controller => 'instructor_sessions', :action => 'new'
  map.resources :instructor_sessions

  map.resources :instructors, :collection => { :emails => [ :get ] },
    :member => { :delete => :get }

  map.resources :facilities, :except => :show, :member => { :delete => :get }

  map.resources :options, :only=> [:index, :update]

  map.resources :programs
  map.resources :program_submissions, :except => [ :edit, :update ], :member => { :delete => :get }

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "main"
  map.help "help", :controller => "main", :action => "help"

  map.autocomplete_map "main/autocomplete_map", :controller => "main", :action => "autocomplete_map"
  map.connect "main/autocomplete_map.:format", :controller => "main", :action => "autocomplete_map"

  map.calendar 'calendar', :controller => 'calendar'
  map.agenda 'calendar/agenda', :controller => 'calendar', :action => 'agenda'
  map.tech_schedule 'calendar/tech_schedule/:tech_id', :controller => 'calendar', :action => 'tech_schedule'
  map.save_preferences 'calendar/save_preferences', :controller => 'calendar', :action => 'save_preferences'
  map.connect 'calendar/:action', :controller => 'calendar'
  map.connect 'calendar/:action.:format', :controller => 'calendar'

  map.notifications 'notifications', :controller => 'notifications'
  map.send_notice 'notifications/send/:event_id', :controller => 'notifications', :action => 'send_notice'
  map.batch_send 'notifications/batch_send', :controller => 'notifications', :action => 'batch_send'
  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
