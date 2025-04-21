TestAuditApp::Application.routes.draw do
  resources :orders, only: :update
  resources :products, only: :create
  patch "/public_facing/update_order/:id", to: "public_facing#update_order", as: "public_update_order"
  resources :other_orders, only: :update
  resources :other_products, only: :create
  resources :sessions, only: :create
end
