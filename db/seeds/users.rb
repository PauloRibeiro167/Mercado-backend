# Criar usuários de teste
users = [
  { email: 'admin@test.com', password: 'password' },
  { email: 'gerente@test.com', password: 'password' },
  { email: 'funcionario@test.com', password: 'password' }
]

users.each do |user_attrs|
  User.find_or_create_by!(email: user_attrs[:email]) do |user|
    user.password = user_attrs[:password]
  end
end