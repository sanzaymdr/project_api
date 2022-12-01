Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace 'api' do
    namespace 'v1' do
      post '/auth/signin', to: 'users#sign_in'

      resource :users, defaults: { format: 'json' } do
        post :signup, to: 'users#sign_up'
      end

      resources :projects, defaults: { format: 'json' } do
        collection do
          get '/my_projects', to: 'projects#user_projects'
        end
      end
    end
  end
end
