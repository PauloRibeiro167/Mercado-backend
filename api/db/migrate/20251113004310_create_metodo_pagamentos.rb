class CreateMetodoPagamentos < ActiveRecord::Migration[8.0]
  def change
    create_table :metodo_pagamentos do |t|
      t.string :nome
      t.string :tipo
      t.text :descricao
      t.decimal :taxa_percentual, precision: 5, scale: 2
      t.decimal :taxa_fixa, precision: 10, scale: 2
      t.integer :prazo_recebimento
      t.decimal :limite_maximo, precision: 10, scale: 2
      t.string :bandeira_cartao
      t.string :parceiro
      t.boolean :ativo
      t.string :icone
      t.integer :ordem
      t.string :moeda, default: "BRL"
      t.boolean :suporte_parcelamento, default: false
      t.integer :numero_max_parcelas
      t.decimal :taxa_parcelamento, precision: 5, scale: 2
      # Campo JSON para configurações específicas do método de pagamento.
      # Exemplos: {"chave_pix": "sua-chave", "tipo_chave": "aleatoria"} para PIX;
      # {"gateway": "Stone", "api_key": "abc123"} para cartões.
      t.json :configuracao_json
      t.references :usuario, foreign_key: true

      t.timestamps
    end
  end
end
