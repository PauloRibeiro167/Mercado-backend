class CreateFuncionarios < ActiveRecord::Migration[8.0]
  def change
    create_table :funcionarios do |t|
      t.string :cpf
      t.string :telefone
      t.date :data_nascimento
      t.date :data_admissao
      t.references :cargo, null: false, foreign_key: true
      t.decimal :salario, precision: 10, scale: 2
      t.references :usuario, null: false, foreign_key: true

      t.references :tipos_contrato, foreign_key: true
      t.integer :jornada_diaria_horas, default: 8
      t.boolean :ativo, default: true

      # Soft Delete (Discard)
      t.datetime :discarded_at
      t.index :discarded_at
      t.timestamps
    end

    add_index :funcionarios, :ativo
    add_index :funcionarios, :cpf, unique: true
  end
end
