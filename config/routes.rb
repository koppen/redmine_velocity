RedmineApp::Application.routes.draw do
  match 'projects/:id/velocities' => 'velocities#index'
end