Rails.application.routes.draw do
  resources :levels

  resources :progresses

  resources :comments

  devise_for :users, :controllers => { :invitations => 'users/invitations', :registrations => 'registrations' }

  devise_scope :user do
    post 'batch_invite', :to => "users/invitations#batch_invite"
  end
  


  resources :users, :only => [:show], :path => "user"

  post "/user/:id/like", :to => "users#like", :as => :user_like
  post "/user/:id/staff-picked", :to => "users#staff_picked", :as => :staff_picked

  resources :posts do
    member do
      put "like", :to => "posts#upvote"
      put "dislike", :to => "posts#downvote"
      get "reply", :to => "posts#new"
      post "report", :to => "posts#report"
    end
    resources :comments
  end
  get "parse_url" => "posts#parse_url"
  root "posts#index"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
