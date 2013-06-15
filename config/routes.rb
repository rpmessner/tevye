Tevye::Application.routes.draw do
  mount Locomotive::Engine => '/locomotive', as: 'locomotive'

  namespace :tevye do
    root to: 'dashboards#show'
    resource :dashboard, only: :show

    resources :pages do
      resource :preview, only: :show
    end
    
    resources :sites
    resources :snippets
    resources :theme_assets 
    resources :content_types
    resources :content_assets
    resources :content_entries
  end
end
