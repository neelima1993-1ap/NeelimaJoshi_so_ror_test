Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'upload#index'
  
  post 'upload', to: "upload#uploadFile"
  get 'download' , to: "upload#downloadFile"
  
  get '/download/file', to: 'upload#download_text_file', as: 'download_file'

end