Rails.application.routes.draw do
  devise_for :users,
             :controllers  => {
                         :registrations => 'customized_devise/registrations',
              }
  devise_scope :user do
      get '/users/sign_up/:referee_code', to:"customized_devise/registrations#new"
  end
    
  #root "pages#home"
  root "forms#show"
  #get '/referfriend', to:"pages#referfriend"
  post '/sendinviting', to:"pages#sendinviting"
  get 'admin', to:"admin#index"
  get 'admin/show', to:"admin#show"
  get '/admin/export', to:"admin#export"
  get 'admin/changestatus/:status/:formname/:unique_id', to:"admin#changestatus"
  get 'dashboard', to:"pages#home"
  get 'form/new' , to: "forms#show" 
  get 'form/checkout' , to: "forms#checkout" 
  get 'form/declined' , to: "forms#declined" 
  post 'form/payment' , to: "forms#payment" 
  get 'form/save' , to: "forms#create"
  get 'form/all' , to: "forms#all"
  get 'form/show' , to: "forms#show"
  get 'form/show/:formname' , to: "forms#show"
  get 'form/index' , to: "forms#index"
  get 'form/submitted/:unique_id' , to: "forms#submitted"
  delete 'form/:unique_id', to: "forms#destroy"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
