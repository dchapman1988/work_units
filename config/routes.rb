WorkUnits::Application.routes.draw do

  root :to => "pages#index"

  devise_for :users do
    get "login", :to => "devise/sessions#new"
    get "logout", :to => "devise/sessions#destroy"
  end

  resources :work_units do
    collection do
      get  :new_average
      post :average
    end
  end

end
