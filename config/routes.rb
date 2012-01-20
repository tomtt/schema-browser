Rails.application.routes.draw do
  match 'schema_browser' => 'schema_browser#index'
end
