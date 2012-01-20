Rails.application.routes.draw do
  match 'schema_browser' => 'schema_browser#index'
  match 'schema_browser/schema' => 'schema_browser#schema'
end
