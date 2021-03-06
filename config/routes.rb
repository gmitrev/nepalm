Rails.application.routes.draw do
  resources :memberships

  resources :projects do
    member do
      post :archive, :star
    end

    resources :stacks do
      resources :comments do
        member do
          post :add_files
        end
      end

      member do
        get :members, :new_member, :files
        post :add_member, :subscribe, :unsubscribe, :archive
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
    resources :work_logs
  end

  get :profile, to: 'users#show'
  put :update_profile, to: 'users#update'

  devise_for :users
  root 'welcome#index'
end
