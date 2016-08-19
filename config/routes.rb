Rails.application.routes.draw do
  mount Blacklight::Oembed::Engine, at: 'oembed'
  root to: 'spotlight/exhibits#index'
  mount Spotlight::Engine, at: 'spotlight'
#  root to: "catalog#index" # replaced by spotlight root path
  blacklight_for :catalog
  devise_for :users

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


#custom vvvvvvvvv

Spotlight::Engine.routes.draw do

    get ':exhibit_id/annotation/:id/show', to: 'catalog#show_annotation', as: 'show_annotation'
    post ':exhibit_id/annotation/:id/get', to: 'catalog#get_annotation'
    post ':exhibit_id/annotation/:id/create', to: 'catalog#create_annotation'
    post ':exhibit_id/annotation/:id/update', to: 'catalog#update_annotation'
    get ':exhibit_id/iiif-service/:id/:region/:size/:rotation/:quality', to: 'catalog#iiif', as: 'iiif'
    get ':exhibit_id/iiif-service/:id/:name', to: 'catalog#iiif_info', as: 'iiif_info'

    get ':exhibit_id/compounds/new', to: 'compounds#new', as: 'compounds_new'
    post ':exhibit_id/compounds', to: 'compounds#create'
    get ':exhibit_id/compounds/:id/edit', to: 'compounds#edit', as: 'edit_compounds'
    put ':exhibit_id/compounds', to: 'compounds#update'
    patch ':exhibit_id/compounds', to: 'compounds#update'

    get ':exhibit_id/compound/new', to: 'compounds#new', as: 'compound_new'
    post ':exhibit_id/compound', to: 'compounds#create'
    get ':exhibit_id/compound/:id/edit', to: 'compounds#edit', as: 'edit_compound'
    put ':exhibit_id/compound', to: 'compounds#update'
    patch ':exhibit_id/compound', to: 'compounds#update'

    get ':exhibit_id/catalog/:id/:page', to: 'catalog#show'
    #get ':exhibit_id/catalog/facet/:id', to: 'catalog#facet'
    get ':exhibit_id/generate_pdfs', to: 'catalog#all_pdfs'
    get ':exhibit_id/generate_pdfs/:id', to: 'catalog#one_pdf'

    post ':exhibit_id/save_screenshot/:id', to: 'catalog#save_screenshot'

    get ':exhibit_id/set_all_thumbs', to: 'catalog#set_all_thumbs'

end

  #custom ^^^^^^^^^^^^^
