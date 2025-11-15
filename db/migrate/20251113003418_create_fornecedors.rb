class CreateFornecedors < ActiveRecord::Migration[8.0]
  def change
    create_table :fornecedors do |t|
      t.string :nome
      t.string :cnpj
      
      # Informações de contato
      t.string :contato_nome
      t.string :telefone
      t.string :telefone_contato
      t.string :email
      
      # Endereço
      t.string :endereco_logradouro
      t.string :endereco_numero
      t.string :endereco_complemento
      t.string :endereco_bairro
      t.string :endereco_cidade
      t.string :endereco_estado
      t.string :endereco_cep
      
      # Informações comerciais
      t.string :lider_referencia
      t.boolean :possui_contrato, default: false, null: false
      t.string :marca_representada
      
      # Referências de usuários
      t.references :user, null: false, foreign_key: true, comment: "Usuário que cadastrou o fornecedor"
      t.references :responsavel, null: false, foreign_key: { to_table: :users }, comment: "Usuário responsável por contatos com este fornecedor"

      t.timestamps
    end
  end
end
