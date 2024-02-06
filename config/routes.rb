Rails.application.routes.draw do
  resources :games, only: [:index, :show]
  resources :frames, only: [:index, :show]
  resources :players, only: [:index, :show]

  root "games#index"

  namespace :api do
    namespace :v1 do
      resources :games do
        post 'start_game', on: :collection, to: 'games#start_game'
        get 'get_game_score', on: :member, to: 'games#get_game_score'
      end

      resources :frames do
        post 'throw_ball', on: :collection, to: 'frames#throw_ball'
      end

      resources :players
    end
  end
end
