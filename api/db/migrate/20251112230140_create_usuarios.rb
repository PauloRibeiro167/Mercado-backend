# frozen_string_literal: true

class CreateUsuarios < ActiveRecord::Migration[8.0]
  def change
    create_table :usuarios do |t|
      # Campos de Autenticação Básica
      t.string :email, null: false
      t.string :senha_digest, null: false

      # Campos de Perfil
      t.string :primeiro_nome, null: false
      t.string :ultimo_nome, null: false
      t.string :nome_usuario

      # Referência correta para role
      t.references :role, foreign_key: true, null: false

      # Controle de Acesso e Status
      t.integer :status, null: false, default: 0

      # Campos para "Esqueci minha senha"
      t.string :token_redefinicao_senha
      t.datetime :enviado_em_redefinicao_senha

      # Campos para Confirmação de E-mail
      t.string :token_confirmacao
      t.datetime :confirmado_em
      t.datetime :enviado_em_confirmacao

      # Soft Delete (Discard)
      t.datetime :discarded_at
      t.index :discarded_at
      t.timestamps
    end

    add_index :usuarios, :email, unique: true
    add_index :usuarios, :nome_usuario, unique: true
    add_index :usuarios, :token_redefinicao_senha, unique: true
  end
end
