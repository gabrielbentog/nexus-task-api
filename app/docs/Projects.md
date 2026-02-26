# API de Projects (Projetos)

Este documento descreve todos os endpoints disponíveis para gerenciar projetos na API.

## Autenticação

Todos os endpoints requerem autenticação via tokens Devise. Inclua os seguintes headers em todas as requisições:

```
access-token: {seu-access-token}
client: {seu-client}
uid: {seu-email}
```

---

## Endpoints

### 1. Listar Projetos

Lista todos os projetos do usuário autenticado, ordenados por data de criação (mais recentes primeiro).

**Endpoint:** `GET /api/projects`

**Headers:**
```
access-token: abc123...
client: xyz789...
uid: user@example.com
```

**Resposta de Sucesso (200):**
```json
[
  {
    "id": "uuid-do-projeto",
    "name": "Nexus Task Manager",
    "key": "NEX",
    "description": "Sistema de gerenciamento de tarefas",
    "createdAt": "2026-02-26T10:30:00.000Z",
    "updatedAt": "2026-02-26T10:30:00.000Z",
    "owner": {
      "id": "uuid-do-usuario",
      "name": "João Silva",
      "email": "joao@example.com"
    }
  },
  {
    "id": "uuid-do-projeto-2",
    "name": "Projeto Alpha",
    "key": "ALPHA",
    "description": "Descrição do projeto",
    "createdAt": "2026-02-25T15:20:00.000Z",
    "updatedAt": "2026-02-25T15:20:00.000Z",
    "owner": {
      "id": "uuid-do-usuario",
      "name": "João Silva",
      "email": "joao@example.com"
    }
  }
]
```

---

### 2. Exibir Projeto

Retorna os detalhes de um projeto específico do usuário autenticado.

**Endpoint:** `GET /api/projects/:id`

**Parâmetros de URL:**
- `id` (obrigatório): UUID do projeto

**Headers:**
```
access-token: abc123...
client: xyz789...
uid: user@example.com
```

**Resposta de Sucesso (200):**
```json
{
  "id": "uuid-do-projeto",
  "name": "Nexus Task Manager",
  "key": "NEX",
  "description": "Sistema de gerenciamento de tarefas",
  "createdAt": "2026-02-26T10:30:00.000Z",
  "updatedAt": "2026-02-26T10:30:00.000Z",
  "owner": {
    "id": "uuid-do-usuario",
    "name": "João Silva",
    "email": "joao@example.com"
  }
}
```

**Resposta de Erro (404):**
```json
{
  "error": "Registro não encontrado"
}
```

---

### 3. Criar Projeto

Cria um novo projeto associado ao usuário autenticado.

**Endpoint:** `POST /api/projects`

**Headers:**
```
Content-Type: application/json
access-token: abc123...
client: xyz789...
uid: user@example.com
```

**Body:**
```json
{
  "project": {
    "name": "Meu Novo Projeto",
    "key": "MNP",
    "description": "Descrição opcional do projeto"
  }
}
```

**Campos:**
- `name` (obrigatório): Nome do projeto
- `key` (obrigatório): Chave única do projeto (ex: "NEX"). Usado para gerar códigos de tarefas
- `description` (opcional): Descrição do projeto

**Resposta de Sucesso (201):**
```json
{
  "id": "uuid-novo-projeto",
  "name": "Meu Novo Projeto",
  "key": "MNP",
  "description": "Descrição opcional do projeto",
  "createdAt": "2026-02-26T11:00:00.000Z",
  "updatedAt": "2026-02-26T11:00:00.000Z",
  "owner": {
    "id": "uuid-do-usuario",
    "name": "João Silva",
    "email": "joao@example.com"
  }
}
```

**Resposta de Erro (422):**
```json
{
  "errors": [
    "Name não pode ficar em branco",
    "Key já está em uso"
  ]
}
```

---

### 4. Atualizar Projeto

Atualiza um projeto existente do usuário autenticado.

**Endpoint:** `PATCH /api/projects/:id` ou `PUT /api/projects/:id`

**Parâmetros de URL:**
- `id` (obrigatório): UUID do projeto

**Headers:**
```
Content-Type: application/json
access-token: abc123...
client: xyz789...
uid: user@example.com
```

**Body:**
```json
{
  "project": {
    "name": "Nome Atualizado",
    "description": "Nova descrição"
  }
}
```

**Campos (todos opcionais):**
- `name`: Novo nome do projeto
- `key`: Nova chave (deve ser única)
- `description`: Nova descrição

**Resposta de Sucesso (200):**
```json
{
  "id": "uuid-do-projeto",
  "name": "Nome Atualizado",
  "key": "NEX",
  "description": "Nova descrição",
  "createdAt": "2026-02-26T10:30:00.000Z",
  "updatedAt": "2026-02-26T11:15:00.000Z",
  "owner": {
    "id": "uuid-do-usuario",
    "name": "João Silva",
    "email": "joao@example.com"
  }
}
```

**Resposta de Erro (422):**
```json
{
  "errors": [
    "Key já está em uso"
  ]
}
```

**Resposta de Erro (404):**
```json
{
  "error": "Registro não encontrado"
}
```

---

### 5. Deletar Projeto

Remove um projeto do usuário autenticado.

**Endpoint:** `DELETE /api/projects/:id`

**Parâmetros de URL:**
- `id` (obrigatório): UUID do projeto

**Headers:**
```
access-token: abc123...
client: xyz789...
uid: user@example.com
```

**Resposta de Sucesso (204):**
```
Sem conteúdo (No Content)
```

**Resposta de Erro (404):**
```json
{
  "error": "Registro não encontrado"
}
```

---

## Validações

Os projetos possuem as seguintes validações:

1. **name**: Obrigatório
2. **key**: Obrigatório e único (não pode haver dois projetos com a mesma chave)
3. **description**: Opcional

---

## Notas Importantes

1. **Escopo de Usuário**: Todos os endpoints retornam/modificam apenas projetos do usuário autenticado
2. **Soft Delete**: Os projetos são deletados permanentemente junto com suas dependências
3. **Formato de Data**: Todas as datas são retornadas no formato ISO 8601
4. **Case Sensitive**: A chave (key) é case-sensitive
5. **Camelização**: Os campos são automaticamente convertidos de snake_case para camelCase nas respostas

---

## Exemplos com cURL

### Criar um projeto:
```bash
curl -X POST http://localhost:3000/api/projects \
  -H "Content-Type: application/json" \
  -H "access-token: seu-token" \
  -H "client: seu-client" \
  -H "uid: seu-email@example.com" \
  -d '{
    "project": {
      "name": "Projeto Teste",
      "key": "TEST",
      "description": "Projeto de teste"
    }
  }'
```

### Listar projetos:
```bash
curl -X GET http://localhost:3000/api/projects \
  -H "access-token: seu-token" \
  -H "client: seu-client" \
  -H "uid: seu-email@example.com"
```

### Atualizar projeto:
```bash
curl -X PATCH http://localhost:3000/api/projects/uuid-do-projeto \
  -H "Content-Type: application/json" \
  -H "access-token: seu-token" \
  -H "client: seu-client" \
  -H "uid: seu-email@example.com" \
  -d '{
    "project": {
      "name": "Nome Atualizado"
    }
  }'
```

### Deletar projeto:
```bash
curl -X DELETE http://localhost:3000/api/projects/uuid-do-projeto \
  -H "access-token: seu-token" \
  -H "client: seu-client" \
  -H "uid: seu-email@example.com"
```

---

## Relacionamentos

- Um **Project** pertence a um **User** (owner)
- Um **User** pode ter vários **Projects**
- Quando um usuário é deletado, todos os seus projetos são removidos (dependent: :destroy)
