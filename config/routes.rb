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
      get 'accept_family/:family_id', to: "patients#accept_family", as: :accept_family
      get 'rem_family/:family_id', to: "patients#rem_family", as: :rem_family
      get 'add_doctor/:doctor_id', to: "patients#add_doctor", as: :add_doctor
      get 'rem_doctor/:doctor_id', to: "patients#rem_doctor", as: :rem_doctor
      get 'praise_doctor/:doctor_id', to: "patients#praise_toggle", as: :pra_doctor
      get :doctors, to: "patients#doctors"
      get :docsearch, to: "patients#doc_search"
    end

    resources :topics, only: [:index, :new, :create] do
      member do
        get :refresh, to: "topics#refresh"
        post :log, to: "topics#log"
        get :deactivate, to: "topics#deactivate"
      end
    end

    resources :updates, only: [:index] do
      member do
        get :read, to: "updates#read"
      end
    end

    resources :schedules, only: [:index, :new, :create, :edit, :update] do
      member do
        get :deactivate, to: "schedules#deactivate"
        get :read, to: "schedules#read"
      end
    end

    resources :documents, only: [:index, :new, :create] do
      member do
        get :download, to: "document#download"
        get :deactivate, to: "documents#deactivate"
        get :read, to: "documents#read"
        delete :delete, to: "documents#destroy"

      end
      collection do
         get :index_ex, to: "documents#index_ex"
      end

    end
  end

end
