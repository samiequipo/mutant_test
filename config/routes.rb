Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post 'mutant', to: 'dna_record#mutant'
      get 'stats', to: 'dna_record#stats'
      post 'counter', to: 'dna_record#counter_sequence'
    end
  end
end
