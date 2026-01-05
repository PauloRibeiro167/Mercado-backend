class CreateCaixas < ActiveRecord::Migration[8.0]
  def change
    create_table :caixas, comment: "Tabela para gerenciar caixas registradoras, incluindo saldo e status de operação" do |t|
      t.string :nome, null: false, comment: "Nome identificador da caixa"
      t.decimal :saldo, precision: 15, scale: 2, default: 0.0, null: false, comment: "Saldo atual da caixa em reais"
      t.decimal :saldo_inicial, precision: 15, scale: 2, default: 0.0, null: false, comment: "Saldo declarado na abertura"
      t.decimal :saldo_final, precision: 15, scale: 2, default: 0.0, null: false, comment: "Saldo apurado no fechamento"
      t.decimal :fundo_abertura, precision: 15, scale: 2, default: 100.0, null: false, comment: "Fundo mínimo exigido para abertura"
      t.decimal :limite_alerta_minimo, precision: 15, scale: 2, default: 75.0, null: false, comment: "Valor mínimo que dispara alerta"
      t.decimal :limite_alerta_maximo, precision: 15, scale: 2, default: 1000.0, null: false, comment: "Valor máximo que dispara alerta"
      t.boolean :ativo, default: true, null: false, comment: "Indica se a caixa está ativa"
      t.string :status, default: "operacional", null: false, comment: "Estado operacional do caixa (operacional, bloqueado, encerrado)"
      t.date :data_abertura, default: -> { 'CURRENT_DATE' }, comment: "Data de abertura da caixa"
      t.references :usuario, foreign_key: true, null: true, comment: "Usuário responsável pela criação da caixa"

      t.timestamps
    end

    # Índices para auditabilidade e performance
    add_index :caixas, :nome, unique: true, comment: "Índice único para garantir nomes únicos"
    add_index :caixas, :ativo, comment: "Índice para filtrar caixas ativas/inativas"
    add_index :caixas, :status, comment: "Índice para filtrar por estado operacional"
    add_index :caixas, :data_abertura, comment: "Índice para consultas por data de abertura"

    # Constraints adicionais para auditabilidade
    add_check_constraint :caixas, "saldo >= 0", name: "saldo_nao_negativo", comment: "Garante que o saldo não seja negativo"
    add_check_constraint :caixas, "saldo_inicial >= 0", name: "saldo_inicial_nao_negativo", comment: "Garante que o saldo inicial não seja negativo"
    add_check_constraint :caixas, "saldo_final >= 0", name: "saldo_final_nao_negativo", comment: "Garante que o saldo final não seja negativo"
    add_check_constraint :caixas, "limite_alerta_minimo >= 0", name: "limite_alerta_minimo_nao_negativo", comment: "Garante que o limite mínimo não seja negativo"
    add_check_constraint :caixas, "limite_alerta_maximo >= 0", name: "limite_alerta_maximo_nao_negativo", comment: "Garante que o limite máximo não seja negativo"
    add_check_constraint :caixas, "limite_alerta_maximo = 0 OR limite_alerta_maximo >= limite_alerta_minimo", name: "limite_alerta_maximo_maior_ou_igual_minimo", comment: "Garante coerência entre limites mínimo e máximo"
    add_check_constraint :caixas, "status IN ('operacional', 'bloqueado', 'encerrado')", name: "status_caixa_valido", comment: "Restringe os estados operacionais permitidos"
    add_check_constraint :caixas, "data_abertura <= CURRENT_DATE", name: "data_abertura_nao_futura", comment: "Impede datas de abertura no futuro"
  end
end
