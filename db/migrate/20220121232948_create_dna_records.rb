class CreateDnaRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :dna_records do |t|
      t.jsonb :dna_sequence, null: false, default: []  
      t.boolean :mutant

      t.timestamps
    end

    add_index :dna_records, :dna_sequence, using: :gin
  end
end