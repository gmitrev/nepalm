Rails.application.routes.draw do

  resources :projects do
    collection do
      get :test
    end
    resources :stacks
  end

  devise_for :users
  root 'projects#index'
end
