# Criar usuários de teste
usuarios = [
  { email: 'admin@test.com', password: 'password', primeiro_nome: 'Admin', ultimo_nome: 'User', papel: 1, status: 0 },
  { email: 'gerente@test.com', password: 'password', primeiro_nome: 'Gerente', ultimo_nome: 'User', papel: 0, status: 0 },
  { email: 'funcionario@test.com', password: 'password', primeiro_nome: 'Funcionario', ultimo_nome: 'User', papel: 0, status: 0 },
  { email: 'ti@test.com', password: 'password', primeiro_nome: 'TI', ultimo_nome: 'User', papel: 1, status: 0 }
]

usuarios.each do |user_attrs|
  Usuario.find_or_create_by!(email: user_attrs[:email]) do |user|
    user.password = user_attrs[:password]
    user.primeiro_nome = user_attrs[:primeiro_nome]
    user.ultimo_nome = user_attrs[:ultimo_nome]
    user.papel = user_attrs[:papel]
    user.status = user_attrs[:status]
  end
end
