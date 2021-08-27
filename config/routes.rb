Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :usuarios, except: [:edit, :update] do
        collection do
          patch :update_email
          patch :update_nombre
        end
      end

      resources :ordenes, except: [:edit, :update] do
        collection do
          patch :update_estado_pago
          patch :update_estado_despacho
        end
      end
    end
  end
end
