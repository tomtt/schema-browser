Rails.application.routes.draw do
  get 'schema_browser' => 'schema_browser#index'
  get 'schema_browser/schema' => 'schema_browser#schema'
end
