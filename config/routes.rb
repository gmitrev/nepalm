Rails.application.routes.draw do
  resources :memberships

  resources :projects do
    collection do
      get :test
    end
    resources :stacks do
      resources :comments

      member do
        get :members, :new_member
        post :add_member, :subscribe, :unsubscribe
      end
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

  get :profile, to: 'users#show'
  put :update_profile, to: 'users#update'

  devise_for :users
  root 'projects#index'
end
