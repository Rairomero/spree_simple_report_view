Spree::Core::Engine.add_routes do
	namespace :admin do
    resources :reports, only: [] do
      collection do
        get :out_of_stock
      end
    end
	end
end
