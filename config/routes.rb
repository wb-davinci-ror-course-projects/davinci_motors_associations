Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root 'cars#index'

  resources :cars do          # for individual cars
    member do
      get 'claim' => 'cars#claim'
    end

    member do
      get 'unclaim' => 'cars#unclaim'
    end


    # collection do
    #   get 'foo'
    # end
  end

  resources :users,
    only: [:new, :create],
    path_names: { new: 'signup' }

  get '/login',
    to: 'sessions#login',
    as: 'login'

  post '/login' => 'sessions#create'

  get '/my_cars',
      to: 'cars#my_cars'

  delete '/logout',
    to: 'sessions#destroy'

end
