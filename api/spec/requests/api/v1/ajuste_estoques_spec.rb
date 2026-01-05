# frozen_string_literal: true

require 'swagger_helper'
require 'securerandom'
require 'jwt'

RSpec.describe 'api/v1/ajuste_estoques', type: :request do
  let!(:role) { Role.create!(name: 'admin') }

  let!(:usuario) do
    Usuario.create!(
      email: 'ajuste.tester@example.com',
      primeiro_nome: 'Ajuste',
      ultimo_nome: 'Tester',
      role: role,
      senha: 'Senha123!',
      senha_confirmation: 'Senha123!'
    )
  end

  let!(:categoria) { Categoria.create!(nome: "Categoria Ajuste") }

  let!(:produto) do
    Produto.create!(
      nome: 'Produto Ajuste',
      descricao: 'Produto genérico para testes de ajuste',
      preco: 9.99,
      preco_custo: 5.50,
      unidade_medida: 'unidade',
      categoria: categoria
    )
  end

  let!(:lote) do
    Lote.create!(
      codigo: SecureRandom.uuid,
      produto: produto,
      quantidade_inicial: 100,
      preco_custo: 5.50,
      data_entrada: Date.current,
      data_validade: Date.current + 30.days
    )
  end

  let!(:estoque) do
    lote.estoque || Estoque.create!(produto: produto, lote: lote, quantidade_atual: lote.quantidade_inicial || 100)
  end

  let!(:existing_ajuste) do
    AjusteEstoque.create!(
      lote: lote,
      usuario: usuario,
      tipo: 'entrada',
      quantidade: 10,
      motivo: 'Carga inicial'
    )
  end

  let(:token) do
    payload = { user_id: usuario.id }
    JWT.encode(payload, Rails.application.secret_key_base, 'HS256')
  end

  let(:Authorization) { "Bearer #{token}" }

  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticate_user!).and_return(true)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(usuario)
  end

  def attach_response_metadata(example)
    raw_response = defined?(response) ? response : nil
    unless raw_response
      puts "[Rswag] WARN #{example.full_description}: nenhuma resposta capturada"
      return
    end

    status = raw_response.status
    body = raw_response.body.to_s

    if body.empty?
      puts "[Rswag] INFO #{example.full_description}: status #{status} sem corpo"
      return
    end

    parsed = JSON.parse(body, symbolize_names: true)
    puts "[Rswag] OK #{example.full_description}: status #{status}"
    example.metadata[:response][:content] = {
      'application/json' => {
        example: parsed
      }
    }
  rescue JSON::ParserError => e
    puts "[Rswag] WARN #{example.full_description}: JSON inválido (#{e.message})"
  end

  def build_payload(ajuste, overrides = {})
    normalized_tipo = (overrides[:tipo] || ajuste.tipo || 'entrada').to_s
    payload = {
      ajuste_estoque: {
        lote_id: overrides.fetch(:lote_id, ajuste.lote_id),
        usuario_id: overrides.fetch(:usuario_id, ajuste.usuario_id),
        tipo: normalized_tipo,
        quantidade: overrides.fetch(:quantidade, ajuste.quantidade || 1),
        motivo: overrides.fetch(:motivo, ajuste.motivo)
      }
    }
    payload[:ajuste_estoque][:quantidade] = overrides[:quantidade] if overrides.key?(:quantidade)
    payload
  end

  AJUSTE_SCHEMA = {
    type: :object,
    properties: {
      id: { type: :integer },
      tipo: { type: :string, nullable: true },
      quantidade: { type: :integer },
      motivo: { type: :string, nullable: true },
      created_at: { type: :string, format: 'date-time' },
      updated_at: { type: :string, format: 'date-time' },
      lote: {
        type: :object,
        nullable: true,
        properties: {
          codigo: { type: :string, nullable: true },
          produto: {
            type: :object,
            nullable: true,
            properties: {
              nome: { type: :string, nullable: true },
              preco: { type: :string, nullable: true },
              unidade_medida: { type: :string, nullable: true },
              descricao: { type: :string, nullable: true }
            }
          }
        }
      },
      usuario: {
        type: :object,
        nullable: true,
        properties: {
          email: { type: :string, nullable: true },
          nome: { type: :string, nullable: true }
        }
      }
    },
    required: %w[id tipo quantidade created_at updated_at]
  }.freeze

  path '/api/v1/ajuste_estoques' do
    get('Lista ajustes de estoque') do
      tags 'Ajuste Estoques'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, description: 'Bearer token'

      response(200, 'sucesso') do
        let(:Authorization) { "Bearer #{token}" }
        schema type: :array, items: AJUSTE_SCHEMA

        run_test!

        after { |example| attach_response_metadata(example) }
      end
    end

    post('Cria ajuste de estoque') do
      tags 'Ajuste Estoques'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, description: 'Bearer token'

      parameter name: :ajuste_estoque, in: :body, schema: {
        type: :object,
        properties: {
          lote_id: { type: :integer },
          usuario_id: { type: :integer, nullable: true },
          tipo: { type: :string, enum: %w[entrada saida ajuste] },
          quantidade: { type: :integer },
          motivo: { type: :string, nullable: true }
        },
        required: %w[lote_id tipo quantidade]
      }

      response(201, 'criado') do
        let(:Authorization) { "Bearer #{token}" }
        let(:ajuste_estoque) { build_payload(existing_ajuste) }

        schema AJUSTE_SCHEMA

        run_test!

        after { |example| attach_response_metadata(example) }
      end

      response(422, 'atributos inválidos') do
        let(:Authorization) { "Bearer #{token}" }
        let(:ajuste_estoque) { build_payload(existing_ajuste, quantidade: 0) }

        run_test!

        after { |example| attach_response_metadata(example) }
      end
    end
  end

  path '/api/v1/ajuste_estoques/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'ID do ajuste de estoque'

    get('Mostra um ajuste de estoque') do
      tags 'Ajuste Estoques'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, description: 'Bearer token'

      response(200, 'sucesso') do
        let(:Authorization) { "Bearer #{token}" }
        let(:id) { existing_ajuste.id }

        schema AJUSTE_SCHEMA

        run_test!

        after { |example| attach_response_metadata(example) }
      end

      response(404, 'não encontrado') do
        let(:Authorization) { "Bearer #{token}" }
        let(:id) { 0 }

        run_test!

        after { |example| attach_response_metadata(example) }
      end
    end

    patch('Atualiza um ajuste de estoque') do
      tags 'Ajuste Estoques'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, description: 'Bearer token'

      parameter name: :ajuste_estoque, in: :body, schema: {
        type: :object,
        properties: {
          lote_id: { type: :integer },
          usuario_id: { type: :integer, nullable: true },
          tipo: { type: :string, enum: %w[entrada saida ajuste] },
          quantidade: { type: :integer },
          motivo: { type: :string, nullable: true }
        }
      }

      response(200, 'atualizado') do
        let(:Authorization) { "Bearer #{token}" }
        let(:id) { existing_ajuste.id }
        let(:ajuste_estoque) do
          build_payload(existing_ajuste, motivo: 'Atualização manual')
        end

        schema AJUSTE_SCHEMA

        run_test!

        after { |example| attach_response_metadata(example) }
      end
    end

    delete('Remove um ajuste de estoque') do
      tags 'Ajuste Estoques'

      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, description: 'Bearer token'

      response(200, 'removido') do
        let(:Authorization) { "Bearer #{token}" }
        let(:id) { existing_ajuste.id }

        run_test!

        after { |example| attach_response_metadata(example) }
      end
    end
  end
end
