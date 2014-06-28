MethodTodo::Application.routes.draw do
  devise_for :users

  get 'toggle_help' => 'frontpage#toggle_help'
  post'timezone' => 'frontpage#set_timezone'

  resources :todos do
    member do
      put "toggle_tickler_status"
      put "toggle_starred_status"
      put 'complete'
      put 'reorder'
    end
  end

  resources :todo_contexts, :path => :contexts, :as => :contexts

  resources :projects

  resources :tags

  root :to => 'frontpage#index'
end
