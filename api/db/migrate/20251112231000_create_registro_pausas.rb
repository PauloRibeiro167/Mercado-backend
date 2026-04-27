class CreateRegistroPausas < ActiveRecord::Migration[8.0]
  def change
    create_table :registro_pausas do |t|
      t.references :funcionario, null: false, foreign_key: true

      t.datetime :inicio, null: false
      t.datetime :fim
      t.string :tipo_pausa, null: false # ex: 'almoco', 'cafe', 'banheiro', 'outros'

      # 0: solicitada/pendente, 1: em_andamento, 2: concluida, 3: rejeitada
      t.integer :status, default: 0, null: false
      t.text :justificativa # Útil para o funcionário explicar o motivo, se necessário

      t.timestamps
    end
  end
end
