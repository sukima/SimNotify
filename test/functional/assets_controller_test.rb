require 'test_helper'

class AssetsControllerTest < ActionController::TestCase
  setup :activate_authlogic

  should_map_resources :assets
  should_map_nested_resources :events, :assets
end
