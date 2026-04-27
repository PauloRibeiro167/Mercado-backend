require "rainbow"

# Verificar dependências
unless Admin::Perfil.exists? && Admin::Permissao.exists?
  puts Rainbow("Erro: Perfis ou permissões não encontrados. Execute as seeds de perfils e permissaos primeiro.").bold.red
  exit
end

config = {
  table_name: "perfil_permissaos",
  model_class: Admin::PerfilPermissao,
  singular: "perfil_permissao",
  plural: "perfil_permissaos",
  recriar_env_var: "RECRIAR_PERFIL_PERMISSAOS",
  recriar: ENV["RECRIAR_PERFIL_PERMISSAOS"] == "true",
  data: [
    {
      perfil_nome: "Administrador",
      permissao_nomes: [
        "Criar Produto", "Editar Produto", "Deletar Produto", "Ver Produto",
        "Criar Venda", "Editar Venda", "Deletar Venda", "Ver Venda",
        "Criar Cliente", "Editar Cliente", "Deletar Cliente", "Ver Cliente",
        "Criar Fornecedor", "Editar Fornecedor", "Deletar Fornecedor", "Ver Fornecedor",
        "Criar Funcionário", "Editar Funcionário", "Deletar Funcionário", "Ver Funcionário",
        "Gerenciar Perfis", "Gerenciar Permissões", "Ver Relatórios", "Gerenciar Caixa"
      ]
    },
    {
      perfil_nome: "Gerente",
      permissao_nomes: [
        "Criar Produto", "Editar Produto", "Ver Produto",
        "Criar Venda", "Editar Venda", "Ver Venda",
        "Criar Cliente", "Editar Cliente", "Ver Cliente",
        "Criar Fornecedor", "Editar Fornecedor", "Ver Fornecedor",
        "Criar Funcionário", "Editar Funcionário", "Ver Funcionário",
        "Ver Relatórios", "Gerenciar Caixa"
      ]
    },
    {
      perfil_nome: "Vendedor",
      permissao_nomes: [
        "Criar Venda", "Editar Venda", "Ver Venda",
        "Ver Produto", "Ver Cliente"
      ]
    }
  ]
}

begin
  ActiveRecord::Base.transaction do
    if config[:recriar]
      config[:model_class].destroy_all
      puts Rainbow("#{config[:table_name]} existentes deletados para recriação").bold.yellow
    end

    criados = 0
    itens_atualizados = 0
    erros_ao_criar = []
    total_antes = config[:model_class].count

    config[:data].each do |record_attrs|
      perfil = Admin::Perfil.find_by(nome: record_attrs[:perfil_nome])
      unless perfil
        erros_ao_criar << { perfil: record_attrs[:perfil_nome], erro: "Perfil não encontrado" }
        next
      end

      record_attrs[:permissao_nomes].each do |permissao_nome|
        begin
          permissao = Admin::Permissao.find_by(nome: permissao_nome)
          unless permissao
            erros_ao_criar << { permissao: permissao_nome, erro: "Permissão não encontrada" }
            next
          end

          record = config[:model_class].find_or_initialize_by(perfil: perfil, permissao: permissao)

          if record.new_record?
            record.save!
            criados += 1
          else
            # Já existe, não atualizar
            itens_atualizados += 1
          end
        rescue => e
          erros_ao_criar << { perfil_permissao: "#{record_attrs[:perfil_nome]} - #{permissao_nome}", erro: e.message }
          puts "Erro ao processar #{config[:singular]} '#{record_attrs[:perfil_nome]} - #{permissao_nome}': #{e.message}"
        end
      end
    end

    itens_criados = config[:model_class].count - total_antes

    if itens_criados == 0 && itens_atualizados == 0
      puts Rainbow("\nNenhum #{config[:singular]} novo criado, pois todos já existem").bold.yellow
    else
      puts Rainbow("\nSeed de carga de #{config[:plural]} executada com sucesso!").bold.green
    end
    puts Rainbow("Seed de carga da tabela ").bold.green + Rainbow("#{config[:table_name]} ").bold.red + Rainbow("concluída com sucesso!").bold.green
  end
rescue => e
  puts Rainbow("Erro geral na seed: #{e.message}").bold.red
end
