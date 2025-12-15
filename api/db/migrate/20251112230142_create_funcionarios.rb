class CreateFuncionarios < ActiveRecord::Migration[8.0]
  def change
    create_table :funcionarios do |t|
      t.string :nome
      t.string :cpf
      t.string :telefone
      t.string :email
      t.date :data_nascimento
      t.date :data_admissao
      t.references :cargo, null: false, foreign_key: true
      t.decimal :salario, precision: 10, scale: 2
      t.references :usuario, null: false, foreign_key: true

      t.references :tipos_contrato, foreign_key: true
      t.integer :jornada_diaria_horas, default: 8
      t.boolean :ativo, default: true

      # Novos campos para pausas
      t.time :hora_inicio_almoco
      t.time :hora_fim_almoco
      t.integer :duracao_pausa_minutos, default: 60

      t.timestamps
    end

    add_index :funcionarios, :ativo
  end
end
