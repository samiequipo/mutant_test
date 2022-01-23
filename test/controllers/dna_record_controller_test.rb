require "test_helper"

class DnaRecordControllerTest < ActionDispatch::IntegrationTest
  teardown do
    Rails.cache.clear
  end
  
  setup do
    @dna_record_1 = DnaRecord.new(dna_sequence: ["AAAA", "TTTT", "CCCC", "GGGG"])
    @dna_record_2 = DnaRecord.new(dna_sequence: ["ACTG", "TGAC", "GTCA", "ATTC"])
    @dna_record_3 = DnaRecord.new(dna_sequence: 
                      ["ATGCGC", "CAGTCC", "TCACGT", "AGCAGG", "CCCCTA", "TCACTG"]
                    )
    @dna_record_invalid_1 = dna_records(:invalid_1)
    @dna_record_invalid_2 = dna_records(:invalid_2)
  end
	
  test 'User with dna_secuence as a mutant' do
		assert_difference('DnaRecord.count', +1) do
			post api_v1_mutant_path,  params: { dna_sequence: @dna_record_1.dna_sequence }, as: :json  
		end

		assert_response :ok
	end

	test 'User with dna_secuence as a human' do
		assert_difference('DnaRecord.count', +1) do
			post api_v1_mutant_path,  params: { dna_sequence: @dna_record_2.dna_sequence }, as: :json  
		end

		assert_response :forbidden
	end

	test 'cannot register user dna_secuence with NxM data' do
		assert_no_difference('DnaRecord.count') do
      post api_v1_mutant_path,  params: { dna_sequence: @dna_record_invalid_1.dna_sequence }, as: :json  
		end

    assert_response 400
	end

	test 'cannot register user dna_secuence with invalid data' do
		assert_no_difference('DnaRecord.count') do
      post api_v1_mutant_path,  params: { dna_sequence: @dna_record_invalid_2.dna_sequence }, as: :json  
		end

    assert_response 400
	end

	test 'Users can see stats between count human and mutant with it ratio' do
    get api_v1_stats_path, as: :json  

    assert_response 200
	end

	test 'Can see number of dna_sequence' do
    post api_v1_counter_path,  params: { dna_sequence: @dna_record_3.dna_sequence }, as: :json  

    assert_response 200
	end
end
