class CreateClientes < ActiveRecord::Migration[8.0]
  def change
    create_table :clientes do |t|
      t.string   :nome, null: false
      t.string   :cpf, null: false
      t.string   :telefone
      t.string   :email
      t.date     :data_nascimento
      t.boolean  :ativo, default: true, null: false

      # Soft Delete (Discard)
      t.datetime :discarded_at
      t.index :discarded_at
      t.timestamps
    end

    add_index :clientes, :cpf, unique: true
    add_index :clientes, :email
    add_index :clientes, :ativo
  end
end
