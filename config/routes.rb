ActionController::Routing::Routes.draw do |map|
  map.connect 'projects/:id/velocities', :controller => 'velocities', :action => 'index'
end