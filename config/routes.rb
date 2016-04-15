Rails.application.routes.draw do

  get '/face' => 'face#index'

  root 'face#index'
  
end
