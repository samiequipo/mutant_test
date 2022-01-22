Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post 'mutant', to: 'dna_record#mutant'
      get 'stats', to: 'dna_record#stats'
      # get 'counter_secuence', to: 'dna_record#counter_secuence'
    end
  end
end
