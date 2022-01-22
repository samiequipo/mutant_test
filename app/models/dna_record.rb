class DnaRecord < ApplicationRecord
  validates :dna_sequence, presence: true
  # , format: { with: /\A[a]*\z/ }
  # validates :dna_sequence_is_array
  
  # Scope
  scope :count_mutant_dna, -> { where(mutant: true).count }
  scope :count_human_dna, -> { where(mutant: false).count }
  
  def is_mutant?
    sequence_number = 
      horizontal_sequence(self.dna_sequence) + 
      vertical_sequence(self.dna_sequence) + 
      oblique_sequence(self.dna_sequence)
    
    return true if sequence_number > 1
    false
  end
  
  # params[dna], is an ArrayString ["ATGCGA","CAGTGC","TTATGT","AGAAGG","CCCCTA","TCACTG"] 
  # params[row], access to each dna_sequence character position
  #   Exp: dna_sequence = "AGGGTA", row = 0, then dna_sequence[row] = "A"
  # params[sequence_counter], if you find a sequence then count += 1
  # params[length], array size
  def horizontal_sequence(dna)
    row = 0
    sequence_counter = 0
    length = dna.length
    
    dna.each do |dna_sequence|
      while length >= row + 4
        sequence_counter += sum_sequence(dna_sequence, row) 
        row += 1
      end
      row = 0
    end

    sequence_counter
  end 

  # Transforming elements from row to column and calling horizontal_sequence
  # ...
  # params[dna], is an ArrayString ["ATGCGA","CAGTGC","TTATGT","AGAAGG","CCCCTA","TCACTG"] 
  # params[length], array size
  # params[dna_array], contain an array of each first dna characters
  # params[row], access to each dna_sequence character position
  # params[sequence_counter], if you find a sequence then count += 1
  #   Exp:  dna.first = ['AGGCA'], dna.first.split('') = ['A','G','G','C','A']
  # => dna.shift, remove first dna element
  def vertical_sequence(dna)
    length = dna.length
    dna_sequence = dna 
    dna_array = dna_sequence.first.split('') # ['AGCT'].split('') => ['A','G','C','T'] 
    dna_sequence = dna_sequence[1..length] # remove first dna element

    dna_sequence.each do |dna_sequence|
      row = 0
      
      dna_array.each do |dna_word|
        dna_word << dna_sequence[row]
        row += 1
      end
    end

    sequence_counter = horizontal_sequence(dna_array)
    sequence_counter
  end

  # params[dna], is an ArrayString ["ATGCGA","CAGTGC","TTATGT","AGAAGG","CCCCTA","TCACTG"] 
  # params[length], array size
  # params[row], access to each dna_sequence character position
  # params[sequence_counter], if you find a sequence then count += 1
  # params[minor_corners_lenght], value of dna.length, control to sum oblique left and rigth
  # params[row_corners], value of row=0, control to sum oblique left and rigth
  def oblique_sequence(dna)
    length = dna.length
    minor_corners_lenght = dna.length
    row = 0
    row_corners = 0
    sequence_counter = 0

    # [('G'), 'A', 'T', ('G')]
    # ['G', ('G'), ('T'), 'G']    => 4x4
    # ['G', ('A'), ('G'), 'G']
    # [('G'), 'A', 'T', ('G')]
    # sum oblique_1 => since [0][0] to [length-1][length-1] and
    # sum oblique_2 => since [0][length-1] to [length-1][0]
    while length >= row + 4
      sequence_counter += sum_oblique_1(dna, row) + sum_oblique_2(dna, row, length-1)
      
      row += 1
    end

    # sum_oblique_left_1       || sum_oblique_rigth_1  
    # sum_oblique_left_2       || sum_oblique_rigth_2
    #  A  (T)  G   C   G   A   ||  A    T    G    C   (G)   A
    # (C)  A  (G)  T   G   C   ||  C    A    G   (T)   G   (C)
    #  T  (T)  A  (T)  T   T   ||  T    T   (A)   T   (T)   T      => 6x6
    #  A   G  (A)  C  (G)  G   ||  A   (G)   A   (C)   G    G
    #  G   C   G  (T)  C  (A)  || (G)   C   (G)   T    C    A
    #  T   C   A   C  (T)  G   ||  T   (C)   A    C    T    G
    # sum_oblique_left_1 => since [1][0] to [(length-1)][(length-1)-1] and
    # sum_oblique_left_2 => since [0][1] to [(length-1)-1][(length-1)] and
    # sum_oblique_right_1 => since [0][(length-1)-1] to [(length-1)-1][0]
    # sum_oblique_right_2 => since [1][length-1] to [1][length-1]
    while minor_corners_lenght > row_corners + 4
      minor_corners_lenght -= 1 
      
      while minor_corners_lenght >= row_corners + 4
        sequence_counter += sum_oblique_left_1(dna, row_corners) + 
          sum_oblique_left_2(dna, row_corners) +
          sum_oblique_right_1(dna, row_corners, minor_corners_lenght-1) + 
          sum_oblique_right_2(dna, row_corners, minor_corners_lenght-1) 
          
        row_corners += 1  
      end

      row_corners = 0
    end

    sequence_counter
  end

  def dna_sequence_is_array
    errors.add(:dna_sequence, "must be an array") unless dna_sequence.kind_of?(Array)
  end

  private
    # dna_sequence.split('')[row..row+3] => ["A", "G", "A", "A"] uniq => ["A", "G", "A", "A"]
    # dna_sequence.uniq.one? => false
    # dna_sequence.split('')[row..row+3] => ["A", "A", "A", "A"] uniq => ["A"]
    # dna_sequence.uniq.one? => true
    def sum_sequence(dna_sequence, row)
      return 1 if dna_sequence.split('')[row..row+3].uniq.one?
    
      0
    end

    def sum_oblique_1(dna_sequence, row)
      return 1 if [dna_sequence[row][row], 
                   dna_sequence[row+1][row+1], 
                   dna_sequence[row+2][row+2], 
                   dna_sequence[row+3][row+3]].uniq.one? 
      
      0             
    end
    
    def sum_oblique_2(dna_sequence, row, length)
      return 1 if [dna_sequence[row][length - row],  
                   dna_sequence[row+1][length-(row+1)], 
                   dna_sequence[row+2][length-(row+2)],  
                   dna_sequence[row+3][length-(row+3)]].uniq.one?
      
      0             
    end

    def sum_oblique_left_1(dna_sequence, row)
      return 1 if [dna_sequence[row][(row+1)], 
                   dna_sequence[row+1][(row+1)+1], 
                   dna_sequence[row+2][(row+1)+2], 
                   dna_sequence[row+3][(row+1)+3]].uniq.one? 
      
      0 
    end

    def sum_oblique_left_2(dna_sequence, row)
      return 1 if [dna_sequence[(row+1)][row], 
                   dna_sequence[(row+1)+1][row+1], 
                   dna_sequence[(row+1)+2][row+2], 
                   dna_sequence[(row+1)+3][row+3]].uniq.one? 

      0 
    end

    def sum_oblique_right_1(dna_sequence, row, length)
      return 1 if [dna_sequence[row][length - row],  
                   dna_sequence[row+1][length-(row+1)], 
                   dna_sequence[row+2][length-(row+2)],  
                   dna_sequence[row+3][length-(row+3)]].uniq.one?
      
      0
    end

    def sum_oblique_right_2(dna_sequence, row, length)
      return 1 if [dna_sequence[(row+1)][(length+1) - row],  
                   dna_sequence[(row+1)+1][(length+1)-(row+1)], 
                   dna_sequence[(row+1)+2][(length+1)-(row+2)],  
                   dna_sequence[(row+1)+3][(length+1)-(row+3)]].uniq.one?
      
      0
    end
end
