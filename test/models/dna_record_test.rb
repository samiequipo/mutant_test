require "test_helper"

class DnaRecordTest < ActiveSupport::TestCase
  setup do
    @dna_record = dna_records(:one)
  end
  
  test 'empty dna_sequence should not be valid' do
    dna_record = DnaRecord.new 
    
    assert dna_record.invalid?
  end

  test 'dna_sequence cannot contain any other data type' do
    dna_record = DnaRecord.new(dna_sequence: '1234') 
    
    assert dna_record.invalid?
  end

  test 'dna_sequence only should be a array' do
    dna_record = DnaRecord.new(dna_sequence: ["ATCCGA","CAGTGC","TTATGT","AGAAGG","CCCCTA","TCACTG"]) 
    
    assert dna_record.valid?
  end
  
  test 'dna_sequence should be min a 4x4' do
    dna_record = DnaRecord.new(dna_sequence: ["ATGCGA","CAGTGC","TTATGT"]) 
    
    assert dna_record.invalid?
  end

  test 'dna_sequence shouldn´t have a NxM Size' do
    dna_record = DnaRecord.new(dna_sequence: ["ATGCGA","CAGTGC","T","TTACAAAC"]) 
    
    assert dna_record.invalid?
  end

  test 'dna_sequence should have a NxN Size' do
    dna_record = DnaRecord.new(dna_sequence: ["ATGC","CAGT","TTAC","TTAC"]) 
    
    assert dna_record.valid?
  end

  test 'dna_sequence should´nt repeat' do
    dna_record = DnaRecord.new(dna_sequence: @dna_record.dna_sequence) 
    
    assert dna_record.invalid?
  end

  test 'dna_sequence should be uniq' do
    dna_record = DnaRecord.new(dna_sequence: ["AAAA","CCCC","TTAC","TTAC"]) 
    
    assert dna_record.valid?
  end

  test 'dna_sequence shouldn´t containt different character than ACTG' do
    dna_record = DnaRecord.new(dna_sequence: ["AABA","CZCC","TNAC","TXAC"]) 
    
    assert dna_record.invalid?
  end
end
