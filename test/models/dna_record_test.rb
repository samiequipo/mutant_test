require "test_helper"

class DnaRecordTest < ActiveSupport::TestCase
  test 'empty dna_sequence should not be valid' do
    dna_record = DnaRecord.new 
    
    assert dna_record.invalid?
  end

  test 'dna_sequence cannot contain any other data type' do
    dna_record = DnaRecord.new(dna_sequence: '1234') 
    
    assert dna_record.invalid?
  end

  test 'dna_sequence only should be a array' do
    dna_record = DnaRecord.new(dna_sequence: ["ATGCGA","CAGTGC","TTATGT","AGAAGG","CCCCTA","TCACTG"]) 
    
    assert dna_record.valid?
  end
  
  test 'dna_sequence should be min a 4x4' do
    dna_record = DnaRecord.new(dna_sequence: ["ATGCGA","CAGTGC","TTATGT"]) 
    
    assert dna_record.invalid?
  end

  test 'dna_sequence should have a NxN Size' do
    dna_record = DnaRecord.new(dna_sequence: ["ATGCGA","CAGTGC","TTA","TTACAAAC"]) 
    
    assert dna_record.invalid?
  end
end
