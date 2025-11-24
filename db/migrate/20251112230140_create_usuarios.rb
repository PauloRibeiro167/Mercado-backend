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
      t.string :nome_usuario # Opcional, mas comum

      # Controle de Acesso e Status (usando Enums)
      # 0 = usuario, 1 = admin, etc.
      t.integer :papel, null: false, default: 0
      # 0 = ativo, 1 = aguardando_confirmacao, 2 = desabilitado, etc.
      t.integer :status, null: false, default: 0

      # Campos para "Esqueci minha senha"
      t.string :token_redefinicao_senha
      t.datetime :enviado_em_redefinicao_senha

      # Campos para Confirmação de E-mail
      t.string :token_confirmacao
      t.datetime :confirmado_em
      t.datetime :enviado_em_confirmacao

      # Campos de Rastreamento (inspirados no Devise)
      t.integer :contagem_acessos, default: 0, null: false
      t.datetime :acesso_atual_em
      t.datetime :ultimo_acesso_em
      t.string :ip_acesso_atual
      t.string :ip_ultimo_acesso

      t.timestamps
    end

    # --- Índices (ESSENCIAIS para performance) ---
    # Garante que o e-mail seja único e acelera buscas
    add_index :usuarios, :email, unique: true

    # Opcional, mas recomendado se você permitir buscas por nome_usuario
    add_index :usuarios, :nome_usuario, unique: true

    # Acelera buscas por tokens
    add_index :usuarios, :token_redefinicao_senha, unique: true
    add_index :usuarios, :token_confirmacao, unique: true

    # Acelera buscas por status e papel (comum em painéis admin)
    add_index :usuarios, :papel
    add_index :usuarios, :status
  end
end
