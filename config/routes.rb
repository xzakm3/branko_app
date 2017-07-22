Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'turkey_data#test'
  get '/stefanovicova', to: 'turkey_data#new'
  get '/borovce', to: 'turkey_data#new'
  get '/cabaj', to: 'turkey_data#new'
  get '/horne_saliby', to: 'turkey_data#new'
  get '/podhorany', to: 'turkey_data#new'
  get '/mala_stefanovicova', to: 'turkey_data#new'
  post '/test', to: 'turkey_data#create'
end
