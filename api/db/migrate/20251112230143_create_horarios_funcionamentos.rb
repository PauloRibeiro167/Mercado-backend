class CreateHorariosFuncionamentos < ActiveRecord::Migration[8.0]
  def change
    create_table :horarios_funcionamentos do |t|
      t.string :dia_semana
      t.date :data_especial
      t.time :hora_inicio
      t.time :hora_fim
      t.string :tipo, default: 'normal'
      t.boolean :ativo, default: true
      t.text :observacao

      t.timestamps
    end

    add_index :horarios_funcionamentos, :dia_semana
    add_index :horarios_funcionamentos, :data_especial
    add_index :horarios_funcionamentos, :tipo
    add_index :horarios_funcionamentos, :ativo
  end
end
