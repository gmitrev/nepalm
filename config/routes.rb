Rails.application.routes.draw do

  resources :projects do
    collection do
      get :test
    end
    resources :stacks do
      resources :task_lists do
        resources :tasks
      end
    end
  end

  resources :tasks do
    member do
      put :toggle
    end
  end

  devise_for :users
  root 'projects#index'
end
