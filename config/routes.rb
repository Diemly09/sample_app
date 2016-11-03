Rails.application.routes.draw do
  root "static_pages#home"
  get "users/new"

  get "static_pages/home"
  get "static_pages/help"
  get "static_pages/about"
  get "/signup", to: "users#new"
end
