Rails.application.routes.draw do

  # resources :comments

  resources :memberships

  # resources :organizations do
  #   member do
  #     get :new_members
  #     post :add_members
  #   end
  # end

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

  devise_for :users
  root 'projects#index'
end
