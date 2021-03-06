Rails.application.routes.draw do
  get 'spotty_api/autocomplete'

  get 'spotty_api/song'

  get 'spotty_api/artist'

  get 'spotty_api/album'

  get 'spotty_api/top_tracks'

  get 'spotty_api/suggest_songs'

  root "application#home"
  devise_for :users
  
  # get 'profiles/edit_public' => 'profiles#edit_public'
  # get 'profiles/edit_private' => 'profiles#edit_private'
  resources :profiles do
    get 'edit_profile' => 'profiles#edit_profile'
    get 'edit_contact' => 'profiles#edit_contact'
    get 'getInstruments' => 'profiles#getInstruments'
    post 'addInstrument' => 'profiles#addInstrument'
    delete 'removeInstrument' => 'profiles#removeInstrument'
  end

  get 'jam_groups/:id/chat' => 'jam_groups#chat', as: 'jam_group_chat' 
  post 'jam_groups/:id/chat' => 'jam_groups#chat', as: 'jam_group_comment' 
  resources :jam_groups
  get 'jam_group_members/list_pending' => 'jam_group_members#list_pending'
  resources :jam_group_members do
    post 'accept_invite' => 'jam_group_members#accept_invite'
    post 'reject_invite' => 'jam_group_members#reject_invite'
  end
  
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
