Rails.application.routes.draw do
  post '/relation', to: 'relations#create'
  delete '/relation', to: 'relations#destroy'

  post '/period', to: 'periods#create'
  put '/latest_period', to: 'periods#update_latest_one'
  get '/followee/periods', to: 'periods#show_followee'
end
