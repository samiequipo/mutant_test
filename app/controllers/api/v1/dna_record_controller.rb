class Api::V1::DnaRecordController < ApplicationController
  def mutant
    dna_record = DnaRecord.new(dna_sequence: dna_record_params[:dna_sequence])
    dna_record.mutant = dna_record.is_mutant?
    
    if dna_record.save
      if dna_record.mutant 
        render json: dna_record, status: 200 
      else
        render json: dna_record, status: 403
      end
    else
      render json: dna_record.errors 
    end 
  end

  def stats
    count_mutant_dna = DnaRecord.count_mutant_dna
    count_human_dna = DnaRecord.count_human_dna

    render json: { 
                   "count_mutant_dna": count_mutant_dna,
                   "count_human_dna": count_human_dna,
                   "ratio": 0.4  
                  }
  end

  # Count number of each dna_secuence, horizontal, oblique or vertical
  # def counter_secuence
  #   dna_record = DnaRecord.new(dna_sequence: params[:dna_sequence])

  # end

  private
    def dna_record_params
      params.permit(:dna_sequence => [])
    end
end
