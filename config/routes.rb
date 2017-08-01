Rails.application.routes.draw do
  get 'users/new'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static_pages#home'
  get '/home', to: 'static_pages#home'
  get '/stefanovicova', to: 'turkey_data#new'
  get '/borovce', to: 'turkey_data#new'
  get '/cabaj', to: 'turkey_data#new'
  get '/horne_saliby', to: 'turkey_data#new'
  get '/podhorany', to: 'turkey_data#new'
  get '/mala_stefanovicova', to: 'turkey_data#new'
  get '/test', to: 'turkey_data#new'
  get  '/signup',  to: 'users#new'
  post '/turkey_data', to: 'turkey_data#create'
end
