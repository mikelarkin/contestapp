Contestapp::Application.routes.draw do

  # Webhook routes
  get "webhooks/uninstall"
  post "webhooks/uninstall"

  get "sessions/new"
  post "sessions/create"
  get "sessions/destroy"

  resources :products do
    collection do
      get 'import'
    end
    resources :variants
  end

  resources :orders do
    collection do
      get 'import'
    end
  end

  resources :contests

  # Dashboard routes
  get "dashboard/index"
  post "create_contest" => 'dashboard#create_contest'
  get "test_connection" => 'dashboard#test_connection'

  # Shopify routes
  get 'shopify/authorize' => 'shopify#authorize'
  post 'shopify/authorize' => 'shopify#authorize'

  get 'shopify/install' => 'shopify#install'
  post 'shopify/install' => 'shopify#install'


  # You can have the root of your site routed with "root"
  root 'dashboard#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end