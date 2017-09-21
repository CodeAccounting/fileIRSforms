Rails.application.routes.draw do
  devise_for :users
  root "pages#home"
  get 'admin', to:"admin#index"
  get 'admin/show', to:"admin#show"
  get '/admin/export', to:"admin#export"
  get 'dashboard', to:"pages#home"
  get 'form/new' , to: "forms#show" 
  get 'form/checkout' , to: "forms#checkout" 
  post 'form/payment' , to: "forms#payment" 
  get 'form/save' , to: "forms#create"
  get 'form/all' , to: "forms#all"
  get 'form/show' , to: "forms#show"
  get 'form/show/:formname' , to: "forms#show"
  get 'form/index' , to: "forms#index"
  delete 'form/:unique_id', to: "forms#destroy"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
