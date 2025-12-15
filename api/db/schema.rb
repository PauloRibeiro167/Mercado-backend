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

ActiveRecord::Schema[8.0].define(version: 2025_12_05_223838) do
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
    t.string "tipo", null: false
    t.integer "quantidade", null: false
    t.text "motivo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lote_id"], name: "index_ajuste_estoques_on_lote_id"
    t.index ["tipo"], name: "index_ajuste_estoques_on_tipo"
    t.index ["usuario_id"], name: "index_ajuste_estoques_on_usuario_id"
  end

  create_table "caixas", comment: "Tabela para gerenciar caixas registradoras, incluindo saldo e status de operação", force: :cascade do |t|
    t.string "nome", null: false, comment: "Nome identificador da caixa"
    t.decimal "saldo", precision: 15, scale: 2, default: "0.0", null: false, comment: "Saldo atual da caixa em reais"
    t.boolean "ativo", default: true, null: false, comment: "Indica se a caixa está ativa"
    t.date "data_abertura", default: -> { "CURRENT_DATE" }, comment: "Data de abertura da caixa"
    t.bigint "usuario_id", comment: "Usuário responsável pela criação da caixa"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ativo"], name: "index_caixas_on_ativo", comment: "Índice para filtrar caixas ativas/inativas"
    t.index ["data_abertura"], name: "index_caixas_on_data_abertura", comment: "Índice para consultas por data de abertura"
    t.index ["nome"], name: "index_caixas_on_nome", unique: true, comment: "Índice único para garantir nomes únicos"
    t.index ["usuario_id"], name: "index_caixas_on_usuario_id"
    t.check_constraint "data_abertura <= CURRENT_DATE", name: "data_abertura_nao_futura"
    t.check_constraint "saldo >= 0::numeric", name: "saldo_nao_negativo"
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
    t.string "nome", null: false
    t.text "descricao"
    t.string "imagem"
    t.integer "status_da_categoria", default: 0, null: false
    t.boolean "excluido", default: false, null: false
    t.integer "taxa_de_lucro"
    t.decimal "imposto", precision: 5, scale: 2, default: "0.0", null: false
    t.integer "ordem", null: false
    t.bigint "categoria_pai_id"
    t.bigint "criado_por_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["categoria_pai_id"], name: "index_categoria_on_categoria_pai_id"
    t.index ["criado_por_id"], name: "index_categoria_on_criado_por_id"
    t.index ["excluido"], name: "index_categoria_on_excluido"
    t.index ["nome"], name: "index_categoria_on_nome", unique: true
    t.index ["ordem"], name: "index_categoria_on_ordem"
    t.index ["status_da_categoria"], name: "index_categoria_on_status_da_categoria"
  end

  create_table "clientes", force: :cascade do |t|
    t.string "nome", null: false
    t.string "cpf", null: false
    t.string "telefone"
    t.string "email"
    t.date "data_nascimento"
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ativo"], name: "index_clientes_on_ativo"
    t.index ["cpf"], name: "index_clientes_on_cpf", unique: true
    t.index ["email"], name: "index_clientes_on_email"
  end

  create_table "conta_pagars", force: :cascade do |t|
    t.bigint "fornecedor_id"
    t.bigint "pedido_compra_id"
    t.bigint "metodo_pagamento_id"
    t.string "numero_documento"
    t.decimal "juros", precision: 10, scale: 2, default: "0.0"
    t.decimal "desconto", precision: 10, scale: 2, default: "0.0"
    t.text "observacoes"
    t.bigint "usuario_id"
    t.integer "numero_de_parcelas", default: 1
    t.integer "parcela_atual", default: 1
    t.decimal "valor_original", precision: 10, scale: 2
    t.bigint "categoria_id"
    t.string "descricao"
    t.decimal "valor", precision: 10, scale: 2
    t.date "data_vencimento"
    t.date "data_pagamento"
    t.string "status"
    t.string "tipo_conta"
    t.boolean "recorrente", default: false
    t.string "intervalo_recorrencia"
    t.integer "numero_recorrencias", default: 0
    t.date "data_proxima_recorrencia"
    t.boolean "paga", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["categoria_id"], name: "index_conta_pagars_on_categoria_id"
    t.index ["data_vencimento"], name: "index_conta_pagars_on_data_vencimento"
    t.index ["fornecedor_id"], name: "index_conta_pagars_on_fornecedor_id"
    t.index ["metodo_pagamento_id"], name: "index_conta_pagars_on_metodo_pagamento_id"
    t.index ["paga"], name: "index_conta_pagars_on_paga"
    t.index ["pedido_compra_id"], name: "index_conta_pagars_on_pedido_compra_id"
    t.index ["recorrente"], name: "index_conta_pagars_on_recorrente"
    t.index ["status"], name: "index_conta_pagars_on_status"
    t.index ["tipo_conta"], name: "index_conta_pagars_on_tipo_conta"
    t.index ["usuario_id"], name: "index_conta_pagars_on_usuario_id"
  end

  create_table "conta_recebers", force: :cascade do |t|
    t.bigint "venda_id"
    t.bigint "cliente_id"
    t.bigint "metodo_pagamento_id"
    t.string "numero_documento"
    t.decimal "juros", precision: 10, scale: 2, default: "0.0"
    t.decimal "desconto", precision: 10, scale: 2, default: "0.0"
    t.text "observacoes"
    t.bigint "usuario_id"
    t.integer "numero_de_parcelas", default: 1
    t.integer "parcela_atual", default: 1
    t.decimal "valor_original", precision: 10, scale: 2
    t.bigint "categoria_id"
    t.string "descricao"
    t.decimal "valor", precision: 10, scale: 2
    t.date "data_vencimento"
    t.date "data_recebimento"
    t.string "status"
    t.string "tipo_conta"
    t.boolean "recorrente", default: false
    t.string "intervalo_recorrencia"
    t.integer "numero_recorrencias", default: 0
    t.date "data_proxima_recorrencia"
    t.boolean "paga", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["categoria_id"], name: "index_conta_recebers_on_categoria_id"
    t.index ["cliente_id"], name: "index_conta_recebers_on_cliente_id"
    t.index ["data_vencimento"], name: "index_conta_recebers_on_data_vencimento"
    t.index ["metodo_pagamento_id"], name: "index_conta_recebers_on_metodo_pagamento_id"
    t.index ["paga"], name: "index_conta_recebers_on_paga"
    t.index ["recorrente"], name: "index_conta_recebers_on_recorrente"
    t.index ["status"], name: "index_conta_recebers_on_status"
    t.index ["tipo_conta"], name: "index_conta_recebers_on_tipo_conta"
    t.index ["usuario_id"], name: "index_conta_recebers_on_usuario_id"
    t.index ["venda_id"], name: "index_conta_recebers_on_venda_id"
  end

  create_table "estoques", force: :cascade do |t|
    t.bigint "produto_id", null: false
    t.bigint "lote_id"
    t.integer "quantidade_atual", default: 0, null: false
    t.integer "quantidade_minima", default: 0
    t.integer "quantidade_ideal", default: 0
    t.decimal "media_vendas_diarias", precision: 5, scale: 2, default: "0.0"
    t.string "localizacao"
    t.datetime "ultima_atualizacao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lote_id"], name: "index_estoques_on_lote_id"
    t.index ["produto_id", "lote_id"], name: "index_estoques_on_produto_id_and_lote_id", unique: true
    t.index ["produto_id"], name: "index_estoques_on_produto_id"
    t.index ["quantidade_atual"], name: "index_estoques_on_quantidade_atual"
  end

  create_table "folha_pagamentos", force: :cascade do |t|
    t.bigint "funcionario_id"
    t.bigint "usuario_id"
    t.date "data_referencia"
    t.integer "dias_trabalhados"
    t.decimal "horas_extras", precision: 5, scale: 2, default: "0.0"
    t.decimal "salario_base", precision: 10, scale: 2
    t.decimal "adicional_horas_extras", precision: 10, scale: 2, default: "0.0"
    t.decimal "inss", precision: 10, scale: 2, default: "0.0"
    t.decimal "fgts", precision: 10, scale: 2, default: "0.0"
    t.decimal "total_bruto", precision: 10, scale: 2, default: "0.0"
    t.decimal "total_liquido", precision: 10, scale: 2
    t.decimal "total_descontos", precision: 10, scale: 2, default: "0.0"
    t.boolean "processada", default: false
    t.bigint "conta_pagar_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conta_pagar_id"], name: "index_folha_pagamentos_on_conta_pagar_id"
    t.index ["data_referencia"], name: "index_folha_pagamentos_on_data_referencia"
    t.index ["funcionario_id"], name: "index_folha_pagamentos_on_funcionario_id"
    t.index ["processada"], name: "index_folha_pagamentos_on_processada"
    t.index ["usuario_id"], name: "index_folha_pagamentos_on_usuario_id"
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
    t.date "data_admissao"
    t.bigint "cargo_id", null: false
    t.decimal "salario", precision: 10, scale: 2
    t.bigint "usuario_id", null: false
    t.bigint "tipos_contrato_id"
    t.integer "jornada_diaria_horas", default: 8
    t.boolean "ativo", default: true
    t.time "hora_inicio_almoco"
    t.time "hora_fim_almoco"
    t.integer "duracao_pausa_minutos", default: 60
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ativo"], name: "index_funcionarios_on_ativo"
    t.index ["cargo_id"], name: "index_funcionarios_on_cargo_id"
    t.index ["tipos_contrato_id"], name: "index_funcionarios_on_tipos_contrato_id"
    t.index ["usuario_id"], name: "index_funcionarios_on_usuario_id"
  end

  create_table "horarios_funcionamentos", force: :cascade do |t|
    t.string "dia_semana"
    t.date "data_especial"
    t.time "hora_inicio"
    t.time "hora_fim"
    t.string "tipo", default: "normal"
    t.boolean "ativo", default: true
    t.text "observacao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ativo"], name: "index_horarios_funcionamentos_on_ativo"
    t.index ["data_especial"], name: "index_horarios_funcionamentos_on_data_especial"
    t.index ["dia_semana"], name: "index_horarios_funcionamentos_on_dia_semana"
    t.index ["tipo"], name: "index_horarios_funcionamentos_on_tipo"
  end

  create_table "item_pedido_compras", force: :cascade do |t|
    t.bigint "pedido_compra_id", null: false
    t.bigint "produto_id", null: false
    t.integer "quantidade_pedida", null: false
    t.integer "quantidade_recebida", default: 0
    t.decimal "preco_unitario", precision: 10, scale: 2, null: false
    t.decimal "subtotal", precision: 10, scale: 2
    t.decimal "desconto", precision: 10, scale: 2, default: "0.0"
    t.date "data_validade"
    t.string "numero_lote"
    t.integer "status", default: 0
    t.datetime "data_recebimento"
    t.text "observacoes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pedido_compra_id"], name: "index_item_pedido_compras_on_pedido_compra_id"
    t.index ["produto_id"], name: "index_item_pedido_compras_on_produto_id"
  end

  create_table "item_vendas", force: :cascade do |t|
    t.bigint "venda_id", null: false
    t.bigint "lote_id", null: false
    t.integer "desconto"
    t.integer "quantidade"
    t.decimal "preco_unitario_vendido"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lote_id"], name: "index_item_vendas_on_lote_id"
    t.index ["venda_id"], name: "index_item_vendas_on_venda_id"
  end

  create_table "lotes", force: :cascade do |t|
    t.string "codigo", null: false
    t.bigint "produto_id", null: false
    t.integer "quantidade_atual"
    t.boolean "controle_de_validade", default: false
    t.integer "quantidade_inicial"
    t.decimal "preco_custo", precision: 10, scale: 2
    t.date "data_validade"
    t.date "data_entrada"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["codigo"], name: "index_lotes_on_codigo", unique: true
    t.index ["produto_id"], name: "index_lotes_on_produto_id"
  end

  create_table "metodo_pagamentos", force: :cascade do |t|
    t.string "nome"
    t.string "tipo"
    t.text "descricao"
    t.decimal "taxa_percentual", precision: 5, scale: 2
    t.decimal "taxa_fixa", precision: 10, scale: 2
    t.integer "prazo_recebimento"
    t.decimal "limite_maximo", precision: 10, scale: 2
    t.string "bandeira_cartao"
    t.string "parceiro"
    t.boolean "ativo"
    t.string "icone"
    t.integer "ordem"
    t.string "moeda", default: "BRL"
    t.boolean "suporte_parcelamento", default: false
    t.integer "numero_max_parcelas"
    t.decimal "taxa_parcelamento", precision: 5, scale: 2
    t.json "configuracao_json"
    t.bigint "usuario_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["usuario_id"], name: "index_metodo_pagamentos_on_usuario_id"
  end

  create_table "movimentacao_caixas", force: :cascade do |t|
    t.datetime "data"
    t.string "descricao"
    t.decimal "valor"
    t.string "tipo"
    t.bigint "usuario_id", null: false
    t.bigint "caixa_id", null: false
    t.string "origem_type"
    t.bigint "origem_id"
    t.bigint "sessao_caixa_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["caixa_id"], name: "index_movimentacao_caixas_on_caixa_id"
    t.index ["origem_type", "origem_id"], name: "index_movimentacao_caixas_on_origem"
    t.index ["sessao_caixa_id"], name: "index_movimentacao_caixas_on_sessao_caixa_id"
    t.index ["usuario_id"], name: "index_movimentacao_caixas_on_usuario_id"
  end

  create_table "pagamentos", force: :cascade do |t|
    t.bigint "pedido_compras_id", null: false
    t.string "tipo_pagamento"
    t.bigint "usuario_id", null: false
    t.date "data_pagamento"
    t.text "observacao"
    t.decimal "valor_pago"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pedido_compras_id"], name: "index_pagamentos_on_pedido_compras_id"
    t.index ["usuario_id"], name: "index_pagamentos_on_usuario_id"
  end

  create_table "pedido_compras", force: :cascade do |t|
    t.string "codigo", null: false
    t.bigint "fornecedor_id", null: false
    t.datetime "data_recebimento"
    t.date "data_pedido", null: false
    t.text "observacao"
    t.decimal "valor_total", precision: 10, scale: 2
    t.string "status", default: "pendente_de_aprovacao", null: false
    t.boolean "recebido", default: false, null: false
    t.bigint "usuario_id", null: false
    t.boolean "aprovado", default: false, null: false
    t.datetime "solicitacao_de_orcamento"
    t.decimal "valor_retorno", precision: 10, scale: 2
    t.string "tipo_pagamento"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["codigo"], name: "index_pedido_compras_on_codigo", unique: true
    t.index ["fornecedor_id"], name: "index_pedido_compras_on_fornecedor_id"
    t.index ["usuario_id"], name: "index_pedido_compras_on_usuario_id"
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
    t.decimal "preco_custo", precision: 10, scale: 2
    t.string "codigo_barras"
    t.string "unidade_medida"
    t.string "marca"
    t.boolean "ativo"
    t.bigint "categoria_id", null: false
    t.integer "estoque_minimo"
    t.string "localizacao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["categoria_id"], name: "index_produtos_on_categoria_id"
  end

  create_table "promocaos", force: :cascade do |t|
    t.bigint "produto_id", null: false
    t.bigint "usuario_id", null: false
    t.string "tipo_promocao"
    t.decimal "preco_promocional", precision: 10, scale: 2
    t.decimal "desconto_percentual", precision: 5, scale: 2
    t.integer "quantidade_minima", default: 1
    t.integer "quantidade_gratis", default: 0
    t.integer "limite_usos", default: 0
    t.boolean "ativo", default: true
    t.integer "prioridade", default: 0
    t.text "descricao"
    t.datetime "data_inicio"
    t.datetime "data_fim"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ativo", "data_inicio", "data_fim"], name: "index_promocaos_on_ativo_and_dates"
    t.index ["ativo"], name: "index_promocaos_on_ativo"
    t.index ["data_fim"], name: "index_promocaos_on_data_fim"
    t.index ["data_inicio"], name: "index_promocaos_on_data_inicio"
    t.index ["prioridade"], name: "index_promocaos_on_prioridade"
    t.index ["produto_id"], name: "index_promocaos_on_produto_id"
    t.index ["usuario_id"], name: "index_promocaos_on_usuario_id"
  end

  create_table "registro_pontos", force: :cascade do |t|
    t.bigint "funcionario_id"
    t.date "data"
    t.time "hora_entrada"
    t.time "hora_saida"
    t.decimal "horas_trabalhadas", precision: 5, scale: 2, default: "0.0"
    t.boolean "aprovado", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aprovado"], name: "index_registro_pontos_on_aprovado"
    t.index ["funcionario_id", "data"], name: "index_registro_pontos_on_funcionario_id_and_data"
    t.index ["funcionario_id"], name: "index_registro_pontos_on_funcionario_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "sessao_caixas", comment: "Tabela para gerenciar sessões de caixas, incluindo abertura, fechamento e supervisão", force: :cascade do |t|
    t.bigint "caixa_id", null: false, comment: "Caixa associada à sessão"
    t.bigint "usuario_abertura_id", null: false, comment: "Usuário que abriu a sessão"
    t.bigint "usuario_fechamento_id", comment: "Usuário que fechou a sessão"
    t.bigint "gerente_supervisor_id", comment: "Gerente responsável pela supervisão do fechamento"
    t.datetime "abertura", null: false, comment: "Data e hora de abertura da sessão"
    t.datetime "fechamento", comment: "Data e hora de fechamento da sessão"
    t.decimal "valor_inicial", precision: 15, scale: 2, default: "0.0", null: false, comment: "Valor inicial da sessão"
    t.decimal "valor_final", precision: 15, scale: 2, comment: "Valor final da sessão"
    t.decimal "saldo_esperado", precision: 15, scale: 2, comment: "Saldo esperado no fechamento"
    t.decimal "diferenca", precision: 15, scale: 2, comment: "Diferença entre saldo esperado e final"
    t.text "observacoes_abertura", comment: "Observações na abertura"
    t.text "observacoes_fechamento", comment: "Observações no fechamento"
    t.string "status", default: "aberta", null: false, comment: "Status da sessão (aberta, fechada, etc.)"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["abertura"], name: "index_sessao_caixas_on_abertura", comment: "Índice para consultas por data de abertura"
    t.index ["caixa_id", "status"], name: "index_sessao_caixas_on_caixa_id_and_status", comment: "Índice composto para caixa e status"
    t.index ["caixa_id"], name: "index_sessao_caixas_on_caixa_id"
    t.index ["fechamento"], name: "index_sessao_caixas_on_fechamento", comment: "Índice para consultas por data de fechamento"
    t.index ["gerente_supervisor_id"], name: "index_sessao_caixas_on_gerente_supervisor_id"
    t.index ["status"], name: "index_sessao_caixas_on_status", comment: "Índice para filtrar por status"
    t.index ["usuario_abertura_id"], name: "index_sessao_caixas_on_usuario_abertura_id"
    t.index ["usuario_fechamento_id"], name: "index_sessao_caixas_on_usuario_fechamento_id"
    t.check_constraint "status::text = ANY (ARRAY['aberta'::character varying, 'fechada'::character varying, 'cancelada'::character varying]::text[])", name: "status_valido"
    t.check_constraint "usuario_abertura_id = usuario_fechamento_id OR fechamento IS NULL", name: "mesmo_usuario_abre_fecha_sessao"
    t.check_constraint "valor_final >= 0::numeric", name: "valor_final_nao_negativo"
    t.check_constraint "valor_inicial >= 0::numeric", name: "valor_inicial_nao_negativo"
  end

  create_table "tipos_contratos", force: :cascade do |t|
    t.string "nome"
    t.text "descricao"
    t.boolean "ativo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nome"], name: "index_tipos_contratos_on_nome", unique: true
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
    t.bigint "role_id", null: false
    t.integer "status", default: 0, null: false
    t.string "token_redefinicao_senha"
    t.datetime "enviado_em_redefinicao_senha"
    t.string "token_confirmacao"
    t.datetime "confirmado_em"
    t.datetime "enviado_em_confirmacao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_usuarios_on_role_id"
  end

  create_table "usuarios_roles", id: false, force: :cascade do |t|
    t.bigint "usuario_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_usuarios_roles_on_role_id"
    t.index ["usuario_id", "role_id"], name: "index_usuarios_roles_on_usuario_id_and_role_id"
    t.index ["usuario_id"], name: "index_usuarios_roles_on_usuario_id"
  end

  create_table "vendas", force: :cascade do |t|
    t.string "status"
    t.decimal "subtotal", precision: 10, scale: 2
    t.decimal "valor_taxa", precision: 10, scale: 2
    t.decimal "valor_total", precision: 10, scale: 2
    t.bigint "metodo_pagamento_id", null: false
    t.bigint "sessao_caixa_id"
    t.datetime "data_venda"
    t.integer "numero_venda"
    t.decimal "valor_pago", precision: 10, scale: 2
    t.decimal "troco", precision: 10, scale: 2
    t.integer "numero_parcelas", default: 1
    t.bigint "cliente_id"
    t.string "motivo_cancelamento"
    t.text "detalhes_cancelamento"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cliente_id"], name: "index_vendas_on_cliente_id"
    t.index ["metodo_pagamento_id"], name: "index_vendas_on_metodo_pagamento_id"
    t.index ["numero_venda"], name: "index_vendas_on_numero_venda", unique: true
    t.index ["sessao_caixa_id"], name: "index_vendas_on_sessao_caixa_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "ajuste_estoques", "lotes"
  add_foreign_key "ajuste_estoques", "usuarios"
  add_foreign_key "caixas", "usuarios"
  add_foreign_key "cargos", "usuarios", column: "criado_por_id"
  add_foreign_key "categoria", "categoria", column: "categoria_pai_id"
  add_foreign_key "categoria", "usuarios", column: "criado_por_id"
  add_foreign_key "conta_pagars", "categoria", column: "categoria_id"
  add_foreign_key "conta_pagars", "fornecedors"
  add_foreign_key "conta_pagars", "metodo_pagamentos"
  add_foreign_key "conta_pagars", "pedido_compras"
  add_foreign_key "conta_pagars", "usuarios"
  add_foreign_key "conta_recebers", "categoria", column: "categoria_id"
  add_foreign_key "conta_recebers", "metodo_pagamentos"
  add_foreign_key "conta_recebers", "usuarios"
  add_foreign_key "estoques", "lotes"
  add_foreign_key "estoques", "produtos"
  add_foreign_key "folha_pagamentos", "conta_pagars"
  add_foreign_key "folha_pagamentos", "funcionarios"
  add_foreign_key "folha_pagamentos", "usuarios"
  add_foreign_key "fornecedors", "usuarios"
  add_foreign_key "fornecedors", "usuarios", column: "responsavel_id"
  add_foreign_key "funcionarios", "cargos"
  add_foreign_key "funcionarios", "tipos_contratos"
  add_foreign_key "funcionarios", "usuarios"
  add_foreign_key "item_pedido_compras", "pedido_compras"
  add_foreign_key "item_pedido_compras", "produtos"
  add_foreign_key "item_vendas", "lotes"
  add_foreign_key "item_vendas", "vendas"
  add_foreign_key "lotes", "produtos"
  add_foreign_key "metodo_pagamentos", "usuarios"
  add_foreign_key "movimentacao_caixas", "caixas"
  add_foreign_key "movimentacao_caixas", "sessao_caixas"
  add_foreign_key "movimentacao_caixas", "usuarios"
  add_foreign_key "pagamentos", "pedido_compras", column: "pedido_compras_id"
  add_foreign_key "pagamentos", "usuarios"
  add_foreign_key "pedido_compras", "fornecedors"
  add_foreign_key "pedido_compras", "usuarios"
  add_foreign_key "perfil_permissaos", "perfils"
  add_foreign_key "perfil_permissaos", "permissaos"
  add_foreign_key "produto_fornecedors", "fornecedors"
  add_foreign_key "produto_fornecedors", "produtos"
  add_foreign_key "produto_fornecedors", "usuarios"
  add_foreign_key "produtos", "categoria", column: "categoria_id"
  add_foreign_key "promocaos", "produtos"
  add_foreign_key "promocaos", "usuarios"
  add_foreign_key "registro_pontos", "funcionarios"
  add_foreign_key "sessao_caixas", "caixas"
  add_foreign_key "sessao_caixas", "usuarios", column: "gerente_supervisor_id"
  add_foreign_key "sessao_caixas", "usuarios", column: "usuario_abertura_id"
  add_foreign_key "sessao_caixas", "usuarios", column: "usuario_fechamento_id"
  add_foreign_key "usuario_perfils", "perfils"
  add_foreign_key "usuario_perfils", "usuarios"
  add_foreign_key "usuarios", "roles"
  add_foreign_key "vendas", "clientes"
  add_foreign_key "vendas", "metodo_pagamentos"
  add_foreign_key "vendas", "sessao_caixas"
end
