require "test_helper"

class DnaRecordTest < ActiveSupport::TestCase
  test 'empty dna_sequence should not be valid' do
    dna_record = DnaRecord.new 
    
    assert dna_record.invalid?
  end

  # test 'dna_sequence only should be a array' do
  #   dna_record = DnaRecord.new(dna_sequence: '1234') 
    
  #   assert dna_record.valid?
  # end
end
