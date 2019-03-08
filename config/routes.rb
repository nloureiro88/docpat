Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :doctors, only: [:index, :show]

  resources :family, only: [:show, :new, :create] do
    member do
      post :add_patient, to: "family#add_patient"
      get :rem_patient, to: "family#rem_patient"

    end
  end

  resources :patients, only: [:show] do
    member do
      get :accept_family, to: "patients#accept_family"
      get :rem_family, to: "patients#rem_family"
      post :add_doctor, to: "patients#add_doctor"
      get :rem_doctor, to: "patients#rem_doctor"
    end

    resources :topics, only: [:index, :show, :new, :create] do
      member do
        get :refresh, to: "topics#refresh"
        post :log, to: "topics#log"
        get :deactivate, to: "topics#deactivate"
      end
    end

    resources :schedules, only: [:index, :new, :create, :edit, :update] do
      member do
        get :deactivate, to: "schedules#deactivate"
      end
    end

    resources :documents, only: [:index, :new, :create] do
      member do
        get :download, to: "document#download"
        get :deactivate, to: "documents#deactivate"
        get :show, to: "documents#show"
        get :edit, to: "documents#edit"
      end
    end
  end

end
