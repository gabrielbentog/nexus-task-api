# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Iniciando seeds..."

# Limpar dados existentes (apenas em desenvolvimento)
if Rails.env.development?
  puts "🧹 Limpando dados existentes..."
  ProjectStatus.destroy_all
  ProjectMember.destroy_all
  Project.destroy_all
  User.destroy_all
end

# Criar usuários
puts "👤 Criando usuários..."

users = [
  {
    name: "João Silva",
    email: "joao@example.com",
    password: "password123",
    password_confirmation: "password123"
  },
  {
    name: "Maria Santos",
    email: "maria@example.com",
    password: "password123",
    password_confirmation: "password123"
  },
  {
    name: "Pedro Costa",
    email: "pedro@example.com",
    password: "password123",
    password_confirmation: "password123"
  },
  {
    name: "Ana Oliveira",
    email: "ana@example.com",
    password: "password123",
    password_confirmation: "password123"
  },
  {
    name: "Carlos Pereira",
    email: "carlos@example.com",
    password: "password123",
    password_confirmation: "password123"
  }
]

created_users = users.map do |user_data|
  user = User.find_or_initialize_by(email: user_data[:email])
  if user.new_record?
    user.assign_attributes(user_data)
    user.save!
    puts "  ✅ Usuário criado: #{user.name} (#{user.email})"
  else
    puts "  ⏭️  Usuário já existe: #{user.name} (#{user.email})"
  end
  user
end

# Criar projetos
puts "\n📁 Criando projetos..."

joao = created_users[0]
maria = created_users[1]
pedro = created_users[2]

projects_data = [
  {
    name: "Nexus Task Manager",
    key: "NEX",
    description: "Sistema de gerenciamento de tarefas e projetos",
    owner: joao
  },
  {
    name: "E-commerce Platform",
    key: "ECOM",
    description: "Plataforma de e-commerce completa",
    owner: maria
  },
  {
    name: "API Gateway",
    key: "GATE",
    description: "Gateway de APIs com autenticação e rate limiting",
    owner: pedro
  },
  {
    name: "Mobile App Backend",
    key: "MOB",
    description: "Backend para aplicativo mobile",
    owner: joao
  }
]

created_projects = projects_data.map do |project_data|
  project = Project.find_or_initialize_by(key: project_data[:key])
  if project.new_record?
    project.assign_attributes(
      name: project_data[:name],
      description: project_data[:description],
      owner: project_data[:owner]
    )
    project.save!
    puts "  ✅ Projeto criado: #{project.name} (#{project.key}) - Owner: #{project.owner.name}"
  else
    puts "  ⏭️  Projeto já existe: #{project.name} (#{project.key})"
  end
  project
end

# Adicionar membros aos projetos
puts "\n👥 Adicionando membros aos projetos..."

ana = created_users[3]
carlos = created_users[4]

members_data = [
  # Nexus Task Manager (João é owner, já adicionado automaticamente como admin)
  { project: created_projects[0], user: maria, role: "admin" },
  { project: created_projects[0], user: pedro, role: "member" },
  { project: created_projects[0], user: ana, role: "viewer" },

  # E-commerce Platform (Maria é owner)
  { project: created_projects[1], user: joao, role: "admin" },
  { project: created_projects[1], user: carlos, role: "member" },
  { project: created_projects[1], user: ana, role: "member" },

  # API Gateway (Pedro é owner)
  { project: created_projects[2], user: maria, role: "member" },
  { project: created_projects[2], user: carlos, role: "viewer" },

  # Mobile App Backend (João é owner)
  { project: created_projects[3], user: pedro, role: "admin" },
  { project: created_projects[3], user: maria, role: "member" }
]

members_data.each do |member_data|
  member = ProjectMember.find_or_initialize_by(
    project_id: member_data[:project].id,
    user_id: member_data[:user].id
  )

  if member.new_record?
    member.role = member_data[:role]
    member.save!
    puts "  ✅ Membro adicionado: #{member_data[:user].name} como #{member_data[:role]} no projeto #{member_data[:project].name}"
  else
    puts "  ⏭️  Membro já existe: #{member_data[:user].name} no projeto #{member_data[:project].name}"
  end
end

puts "\n✨ Seeds concluído com sucesso!"
puts "\n📊 Resumo:"
puts "  👤 Usuários: #{User.count}"
puts "  📁 Projetos: #{Project.count}"
puts "  👥 Membros: #{ProjectMember.count}"
puts "  📊 Status: #{ProjectStatus.count}"

puts "\n🔑 Credenciais para teste:"
puts "  Email: joao@example.com | Senha: password123"
puts "  Email: maria@example.com | Senha: password123"
puts "  Email: pedro@example.com | Senha: password123"
puts "  Email: ana@example.com | Senha: password123"
puts "  Email: carlos@example.com | Senha: password123"
