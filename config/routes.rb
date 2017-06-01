Rails.application.routes.draw do
  root "forms#index"
  get 'form/new' , to: "forms#show"
  get 'form/save' , to: "forms#create"
  get 'form/all' , to: "forms#all"
  get 'form/show' , to: "forms#show"
  get 'form/index' , to: "forms#index"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
