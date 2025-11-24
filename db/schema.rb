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

ActiveRecord::Schema[8.0].define(version: 2025_11_15_220935) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

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
    t.text "descricao"
    t.text "atribuicoes"
    t.bigint "criado_por_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["criado_por_id"], name: "index_cargos_on_criado_por_id"
    t.index ["nome"], name: "index_cargos_on_nome", unique: true
  end

  create_table "categoria", force: :cascade do |t|
    t.string "nome"
    t.text "descricao"
    t.text "imagem"
    t.boolean "status", default: true, null: false
    t.integer "ordem"
    t.bigint "categoria_pai_id"
    t.bigint "criado_por_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["categoria_pai_id"], name: "index_categoria_on_categoria_pai_id"
    t.index ["criado_por_id"], name: "index_categoria_on_criado_por_id"
  end

  create_table "clientes", force: :cascade do |t|
    t.string "nome"
    t.string "cpf"
    t.string "telefone"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cpf"], name: "index_clientes_on_cpf", unique: true
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
    t.bigint "usuario_id", null: false, comment: "Usuário que cadastrou o fornecedor"
    t.bigint "responsavel_id", null: false, comment: "Usuário responsável por contatos com este fornecedor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["responsavel_id"], name: "index_fornecedors_on_responsavel_id"
    t.index ["usuario_id"], name: "index_fornecedors_on_usuario_id"
  end

  create_table "funcionarios", force: :cascade do |t|
    t.string "nome"
    t.string "cpf"
    t.string "telefone"
    t.string "email"
    t.date "data_nascimento"
    t.bigint "cargo_id", null: false
    t.decimal "salario", precision: 10, scale: 2
    t.bigint "usuario_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cargo_id"], name: "index_funcionarios_on_cargo_id"
    t.index ["usuario_id"], name: "index_funcionarios_on_usuario_id"
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
    t.bigint "usuario_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fornecedor_id"], name: "index_produto_fornecedors_on_fornecedor_id"
    t.index ["produto_id"], name: "index_produto_fornecedors_on_produto_id"
    t.index ["usuario_id"], name: "index_produto_fornecedors_on_usuario_id"
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
    t.bigint "usuario_id", null: false
    t.string "tipo_promocao"
    t.decimal "preco_promocional", precision: 10, scale: 2
    t.datetime "data_inicio"
    t.datetime "data_fim"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["produto_id"], name: "index_promocaos_on_produto_id"
    t.index ["usuario_id"], name: "index_promocaos_on_usuario_id"
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

  create_table "usuario_perfils", force: :cascade do |t|
    t.bigint "usuario_id", null: false
    t.bigint "perfil_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["perfil_id"], name: "index_usuario_perfils_on_perfil_id"
    t.index ["usuario_id"], name: "index_usuario_perfils_on_usuario_id"
  end

  create_table "usuarios", force: :cascade do |t|
    t.string "email", null: false
    t.string "senha_digest", null: false
    t.string "primeiro_nome", null: false
    t.string "ultimo_nome", null: false
    t.string "nome_usuario"
    t.integer "papel", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.string "token_redefinicao_senha"
    t.datetime "enviado_em_redefinicao_senha"
    t.string "token_confirmacao"
    t.datetime "confirmado_em"
    t.datetime "enviado_em_confirmacao"
    t.integer "contagem_acessos", default: 0, null: false
    t.datetime "acesso_atual_em"
    t.datetime "ultimo_acesso_em"
    t.string "ip_acesso_atual"
    t.string "ip_ultimo_acesso"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_usuarios_on_email", unique: true
    t.index ["nome_usuario"], name: "index_usuarios_on_nome_usuario", unique: true
    t.index ["papel"], name: "index_usuarios_on_papel"
    t.index ["status"], name: "index_usuarios_on_status"
    t.index ["token_confirmacao"], name: "index_usuarios_on_token_confirmacao", unique: true
    t.index ["token_redefinicao_senha"], name: "index_usuarios_on_token_redefinicao_senha", unique: true
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "ajuste_estoques", "lotes"
  add_foreign_key "cargos", "usuarios", column: "criado_por_id"
  add_foreign_key "categoria", "categoria", column: "categoria_pai_id"
  add_foreign_key "categoria", "usuarios", column: "criado_por_id"
  add_foreign_key "conta_pagars", "fornecedors"
  add_foreign_key "conta_pagars", "pedido_compras"
  add_foreign_key "fornecedors", "usuarios"
  add_foreign_key "fornecedors", "usuarios", column: "responsavel_id"
  add_foreign_key "funcionarios", "cargos"
  add_foreign_key "funcionarios", "usuarios"
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
  add_foreign_key "produto_fornecedors", "usuarios"
  add_foreign_key "produtos", "categoria", column: "categoria_id"
  add_foreign_key "promocaos", "produtos"
  add_foreign_key "promocaos", "usuarios"
  add_foreign_key "usuario_perfils", "perfils"
  add_foreign_key "usuario_perfils", "usuarios"
  add_foreign_key "vendas", "metodo_pagamentos"
end
