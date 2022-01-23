class Api::V1::DnaRecordController < ApplicationController

  # Human is a mutant?
  # params[dna_sequence], user send your dna_sequence
  # params[mutant], boolean, true if user is a mutant, false if not
  # If dna_sequence is valid then check if user is a mutant througth 
  #   function[is_mutant?], then ask and return status depending your state
  # If not valid then return object errors with their status  

  # POST /api/v1/mutant
  # {
  #   "dna_sequence": ["AAAAGA","CAGTGC","TTATGT","AGAAGG","CCCCTA","TCACTG"]
  # }
  def mutant
    dna_record = DnaRecord.new(dna_sequence: params[:dna_sequence])
    
    if dna_record.valid?
      dna_record.mutant = dna_record.is_mutant?
      dna_record.save
      
      if dna_record.mutant 
        render status: 200 
      else
        render status: 403
      end
    else
      render json: dna_record.errors, status: 400
    end 
  end

  # Stats between human and mutant
  # params[count_mutant_dna], count of all mutant = true
  # params[count_human_dna], count of all mutant = false
  # then render json with count human, mutant and their ratio
  # GET /api/v1/stats
  def stats
    count_mutant_dna = DnaRecord.count_mutant_dna
    count_human_dna = DnaRecord.count_human_dna

    render json: { 
                   "count_mutant_dna": count_mutant_dna,
                   "count_human_dna": count_human_dna,
                   "ratio": ratio(count_mutant_dna, count_human_dna)
                  }
  end

  # OPTIONAL method to know << How many mutant sequences are there? >>
  # POST /api/v1/counter
  def counter_sequence
    dna_record = DnaRecord.new(dna_sequence: params[:dna_sequence])
    number_dna_sequence = dna_record.counter_sequence 
      
    render json: { number_dna_sequence: number_dna_sequence }, status: 200 
  end

  private
    def dna_record_params
      params.permit(:dna_sequence => [])
    end

    def ratio(count_mutant_dna, count_human_dna)
      return count_mutant_dna/count_human_dna.to_f if count_human_dna != 0

      0
    end
end
