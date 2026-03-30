Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

      # ── Auth ──────────────────────────────────────────────────
      post "auth/signup",  to: "auth#signup"
      post "auth/login",   to: "auth#login"
      get  "auth/me",      to: "auth#me"

      # ── Contacts ──────────────────────────────────────────────
      resources :contacts do
        member do
          get :deals
          get :activities
        end
      end

      # ── Companies ─────────────────────────────────────────────
      resources :companies do
        member do
          get :contacts
          get :deals
        end
      end

      # ── Deals ─────────────────────────────────────────────────
      resources :deals do
        member do
          patch :update_stage
        end
      end

      # ── Activities ────────────────────────────────────────────
      resources :activities

      # ── Dashboard ─────────────────────────────────────────────
      get "dashboard/stats", to: "dashboard#stats"

    end
  end

  # Health check
  get "up", to: proc { [200, {}, ["OK"]] }
end
