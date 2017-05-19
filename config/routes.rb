Rails.application.routes.draw do
  root "pages#home"
  get 'form/new' , to: "forms#new"
  get 'form/save' , to: "forms#create"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
