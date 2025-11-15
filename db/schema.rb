# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_11_13_140408) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "ajuste_estoques", force: :cascade do |t|
    t.bigint "lote_id", null: false
    t.bigint "usuario_id"
    t.string "tipo"
    t.integer "quantidade"
    t.text "motivo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lote_id"], name: "index_ajuste_estoques_on_lote_id"
    t.index ["usuario_id"], name: "index_ajuste_estoques_on_usuario_id"
  end

  create_table "cargos", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nome"], name: "index_cargos_on_nome", unique: true
  end

  create_table "categoria", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clientes", force: :cascade do |t|
    t.string "nome"
    t.string "cpf"
    t.string "telefone"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "conta_pagars", force: :cascade do |t|
    t.bigint "fornecedor_id", null: false
    t.bigint "pedido_compra_id", null: false
    t.string "descricao"
    t.decimal "valor", precision: 10, scale: 2
    t.date "data_vencimento"
    t.date "data_pagamento"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fornecedor_id"], name: "index_conta_pagars_on_fornecedor_id"
    t.index ["pedido_compra_id"], name: "index_conta_pagars_on_pedido_compra_id"
  end

  create_table "conta_recebers", force: :cascade do |t|
    t.bigint "venda_id"
    t.bigint "cliente_id"
    t.string "descricao"
    t.decimal "valor", precision: 10, scale: 2
    t.date "data_vencimento"
    t.date "data_recebimento"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cliente_id"], name: "index_conta_recebers_on_cliente_id"
    t.index ["venda_id"], name: "index_conta_recebers_on_venda_id"
  end

  create_table "fornecedors", force: :cascade do |t|
    t.string "nome"
    t.string "cnpj"
    t.string "contato_nome"
    t.string "telefone"
    t.string "telefone_contato"
    t.string "email"
    t.string "endereco_logradouro"
    t.string "endereco_numero"
    t.string "endereco_complemento"
    t.string "endereco_bairro"
    t.string "endereco_cidade"
    t.string "endereco_estado"
    t.string "endereco_cep"
    t.string "lider_referencia"
    t.boolean "possui_contrato", default: false, null: false
    t.string "marca_representada"
    t.bigint "user_id", null: false, comment: "Usuário que cadastrou o fornecedor"
    t.bigint "responsavel_id", null: false, comment: "Usuário responsável por contatos com este fornecedor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["responsavel_id"], name: "index_fornecedors_on_responsavel_id"
    t.index ["user_id"], name: "index_fornecedors_on_user_id"
  end

  create_table "funcionarios", force: :cascade do |t|
    t.string "nome"
    t.string "cpf"
    t.string "telefone"
    t.string "email"
    t.date "data_nascimento"
    t.string "cargo"
    t.decimal "salario", precision: 10, scale: 2
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_funcionarios_on_user_id"
  end

  create_table "item_pedido_compras", force: :cascade do |t|
    t.bigint "pedido_compra_id", null: false
    t.bigint "produto_id", null: false
    t.integer "quantidade"
    t.decimal "preco_custo_negociado", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pedido_compra_id"], name: "index_item_pedido_compras_on_pedido_compra_id"
    t.index ["produto_id"], name: "index_item_pedido_compras_on_produto_id"
  end

  create_table "item_vendas", force: :cascade do |t|
    t.bigint "venda_id", null: false
    t.bigint "lote_id", null: false
    t.integer "quantidade"
    t.decimal "preco_unitario_vendido", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lote_id"], name: "index_item_vendas_on_lote_id"
    t.index ["venda_id"], name: "index_item_vendas_on_venda_id"
  end

  create_table "lotes", force: :cascade do |t|
    t.bigint "produto_id", null: false
    t.integer "quantidade_atual"
    t.integer "quantidade_inicial"
    t.decimal "preco_custo", precision: 10, scale: 2
    t.date "data_validade"
    t.date "data_entrada"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["produto_id"], name: "index_lotes_on_produto_id"
  end

  create_table "metodo_pagamentos", force: :cascade do |t|
    t.string "nome"
    t.decimal "taxa_percentual", precision: 5, scale: 2
    t.decimal "taxa_fixa", precision: 10, scale: 2
    t.boolean "ativo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "movimentacao_caixas", force: :cascade do |t|
    t.datetime "data"
    t.string "descricao"
    t.decimal "valor", precision: 10, scale: 2
    t.string "tipo"
    t.bigint "conta_pagar_id", null: false
    t.bigint "conta_receber_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conta_pagar_id"], name: "index_movimentacao_caixas_on_conta_pagar_id"
    t.index ["conta_receber_id"], name: "index_movimentacao_caixas_on_conta_receber_id"
  end

  create_table "pedido_compras", force: :cascade do |t|
    t.bigint "fornecedor_id", null: false
    t.date "data_pedido"
    t.string "status"
    t.decimal "valor_total", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fornecedor_id"], name: "index_pedido_compras_on_fornecedor_id"
  end

  create_table "perfil_permissaos", force: :cascade do |t|
    t.bigint "perfil_id", null: false
    t.bigint "permissao_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["perfil_id"], name: "index_perfil_permissaos_on_perfil_id"
    t.index ["permissao_id"], name: "index_perfil_permissaos_on_permissao_id"
  end

  create_table "perfils", force: :cascade do |t|
    t.string "nome"
    t.text "descricao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nome"], name: "index_perfils_on_nome", unique: true
  end

  create_table "permissaos", force: :cascade do |t|
    t.string "nome"
    t.string "chave_acao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chave_acao"], name: "index_permissaos_on_chave_acao", unique: true
    t.index ["nome"], name: "index_permissaos_on_nome", unique: true
  end

  create_table "produto_fornecedors", force: :cascade do |t|
    t.bigint "produto_id", null: false
    t.bigint "fornecedor_id", null: false
    t.decimal "preco_custo"
    t.integer "prazo_entrega_dias"
    t.string "codigo_fornecedor"
    t.boolean "ativo"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fornecedor_id"], name: "index_produto_fornecedors_on_fornecedor_id"
    t.index ["produto_id"], name: "index_produto_fornecedors_on_produto_id"
    t.index ["user_id"], name: "index_produto_fornecedors_on_user_id"
  end

  create_table "produtos", force: :cascade do |t|
    t.string "nome"
    t.text "descricao"
    t.decimal "preco", precision: 10, scale: 2
    t.string "codigo_barras"
    t.string "unidade_medida"
    t.string "marca"
    t.boolean "ativo"
    t.bigint "categoria_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "estoque_minimo"
    t.string "localizacao"
    t.index ["categoria_id"], name: "index_produtos_on_categoria_id"
  end

  create_table "promocaos", force: :cascade do |t|
    t.bigint "produto_id", null: false
    t.bigint "user_id", null: false
    t.string "tipo_promocao"
    t.decimal "preco_promocional", precision: 10, scale: 2
    t.datetime "data_inicio"
    t.datetime "data_fim"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["produto_id"], name: "index_promocaos_on_produto_id"
    t.index ["user_id"], name: "index_promocaos_on_user_id"
  end

  create_table "sessao_caixas", force: :cascade do |t|
    t.bigint "usuario_id"
    t.datetime "abertura"
    t.datetime "fechamento"
    t.decimal "valor_inicial"
    t.decimal "valor_final"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["usuario_id"], name: "index_sessao_caixas_on_usuario_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "usuario_perfils", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "perfil_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["perfil_id"], name: "index_usuario_perfils_on_perfil_id"
    t.index ["user_id"], name: "index_usuario_perfils_on_user_id"
  end

  create_table "vendas", force: :cascade do |t|
    t.string "status"
    t.decimal "subtotal", precision: 10, scale: 2
    t.decimal "valor_taxa", precision: 10, scale: 2
    t.decimal "valor_total", precision: 10, scale: 2
    t.bigint "metodo_pagamento_id", null: false
    t.datetime "data_venda"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["metodo_pagamento_id"], name: "index_vendas_on_metodo_pagamento_id"
  end

  add_foreign_key "ajuste_estoques", "lotes"
  add_foreign_key "conta_pagars", "fornecedors"
  add_foreign_key "conta_pagars", "pedido_compras"
  add_foreign_key "fornecedors", "users"
  add_foreign_key "fornecedors", "users", column: "responsavel_id"
  add_foreign_key "funcionarios", "users"
  add_foreign_key "item_pedido_compras", "pedido_compras"
  add_foreign_key "item_pedido_compras", "produtos"
  add_foreign_key "item_vendas", "lotes"
  add_foreign_key "item_vendas", "vendas"
  add_foreign_key "lotes", "produtos"
  add_foreign_key "movimentacao_caixas", "conta_pagars"
  add_foreign_key "movimentacao_caixas", "conta_recebers"
  add_foreign_key "pedido_compras", "fornecedors"
  add_foreign_key "perfil_permissaos", "perfils"
  add_foreign_key "perfil_permissaos", "permissaos"
  add_foreign_key "produto_fornecedors", "fornecedors"
  add_foreign_key "produto_fornecedors", "produtos"
  add_foreign_key "produto_fornecedors", "users"
  add_foreign_key "produtos", "categoria", column: "categoria_id"
  add_foreign_key "promocaos", "produtos"
  add_foreign_key "promocaos", "users"
  add_foreign_key "usuario_perfils", "perfils"
  add_foreign_key "usuario_perfils", "users"
  add_foreign_key "vendas", "metodo_pagamentos"
end
