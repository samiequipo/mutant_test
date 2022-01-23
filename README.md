# README

# 1) In port http 3000 - http://localhost:3000

# 1.1) Request /mutant
# - Indicates if the person is a mutant or not, returning status 200 or 403 depending on the case 
POST http://localhost:3000/api/v1/mutant

# - Place the following NxN object in the request:

{
  dna_sequence: ["ATGCGA","CAGTGC","TTATGT","AGAAGG","CCCCTA","TCACTG"]
}

# 1.2) Request /stats
# - Statistics between the number of mutants, number of humans and ratio
GET http://localhost:3000/api/v1/stats

# 1.3) Request /counter - Optional *
# - know how many matches exist in an NxN array
POST http://localhost:3000/api/v1/counter
# - Place the following NxN object in the request:

{
  dna_sequence: ["ATGCGA","CAGTGC","TTATGT","AGAAGG","CCCCTA","TCACTG"]
}

# 2) In herokuapp - https://mutant-test.herokuapp.com/

# 2.1) Request /mutant
# - Indicates if the person is a mutant or not, returning status 200 or 403 depending on the case 
POST https://mutant-test.herokuapp.com/api/v1/mutant

# - Place the following NxN object in the request:

{
  dna_sequence: ["ATGCGA","CAGTGC","TTATGT","AGAAGG","CCCCTA","TCACTG"]
}

# 2.2) Request /stats
# - Statistics between the number of mutants, number of humans and ratio
GET https://mutant-test.herokuapp.com/api/v1/stats

# 2.3) Request /counter - Optional *
# - know how many matches exist in an NxN array
POST https://mutant-test.herokuapp.com/api/v1/counter
# - Place the following NxN object in the request:

{
  dna_sequence: ["ATGCGA","CAGTGC","TTATGT","AGAAGG","CCCCTA","TCACTG"]
}