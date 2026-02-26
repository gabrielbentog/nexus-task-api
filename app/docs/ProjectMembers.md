# API de Project Members (Membros do Projeto)

Este documento descreve todos os endpoints disponíveis para gerenciar membros de projetos na API.

## Autenticação

Todos os endpoints requerem autenticação via tokens Devise. Inclua os seguintes headers em todas as requisições:

```
access-token: {seu-access-token}
client: {seu-client}
uid: {seu-email}
```

---

## Conceitos Importantes

### Hierarquia de Permissões

1. **Owner (Dono)**: Criador do projeto. Tem todas as permissões, incluindo deletar o projeto.
2. **Admin**: Pode adicionar/remover membros e alterar permissões. Não pode deletar o projeto.
3. **Member**: Pode visualizar e editar conteúdo do projeto.
4. **Viewer**: Pode apenas visualizar o projeto (somente leitura).

### Regras de Acesso

- Apenas o **owner** e **admins** podem adicionar, editar ou remover membros
- O **owner** não pode ser removido dos membros
- Cada combinação de `project_id + user_id` é única (chave primária composta)

---

## Endpoints

### 1. Listar Membros do Projeto

Lista todos os membros de um projeto específico.

**Endpoint:** `GET /api/projects/:project_id/members`

**Parâmetros de URL:**
- `project_id` (obrigatório): UUID do projeto

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
    "projectId": "uuid-do-projeto",
    "userId": "uuid-do-usuario-1",
    "role": "admin",
    "joinedAt": "2026-02-26T10:00:00.000Z",
    "user": {
      "id": "uuid-do-usuario-1",
      "name": "Maria Silva",
      "email": "maria@example.com"
    },
    "project": {
      "id": "uuid-do-projeto",
      "name": "Nexus Task Manager",
      "key": "NEX"
    }
  },
  {
    "projectId": "uuid-do-projeto",
    "userId": "uuid-do-usuario-2",
    "role": "member",
    "joinedAt": "2026-02-26T11:30:00.000Z",
    "user": {
      "id": "uuid-do-usuario-2",
      "name": "João Santos",
      "email": "joao@example.com"
    },
    "project": {
      "id": "uuid-do-projeto",
      "name": "Nexus Task Manager",
      "key": "NEX"
    }
  }
]
```

**Resposta de Erro (404):**
```json
{
  "error": "Projeto não encontrado"
}
```

---

### 2. Adicionar Membro ao Projeto

Adiciona um novo membro ao projeto. Apenas o owner ou admins podem executar esta ação.

**Endpoint:** `POST /api/projects/:project_id/members`

**Parâmetros de URL:**
- `project_id` (obrigatório): UUID do projeto

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
  "projectMember": {
    "userId": "uuid-do-usuario",
    "role": "member"
  }
}
```

**Campos:**
- `userId` (obrigatório): UUID do usuário a ser adicionado
- `role` (obrigatório): Papel do membro no projeto. Valores permitidos: `"admin"`, `"member"`, `"viewer"`

**Resposta de Sucesso (201):**
```json
{
  "projectId": "uuid-do-projeto",
  "userId": "uuid-do-usuario",
  "role": "member",
  "joinedAt": "2026-02-26T12:00:00.000Z",
  "user": {
    "id": "uuid-do-usuario",
    "name": "Pedro Costa",
    "email": "pedro@example.com"
  },
  "project": {
    "id": "uuid-do-projeto",
    "name": "Nexus Task Manager",
    "key": "NEX"
  }
}
```

**Resposta de Erro (403):**
```json
{
  "error": "Você não tem permissão para realizar esta ação"
}
```

**Resposta de Erro (422):**
```json
{
  "errors": [
    "User já está no projeto",
    "Role não está incluído na lista"
  ]
}
```

---

### 3. Atualizar Papel do Membro

Atualiza o papel (role) de um membro no projeto. Apenas o owner ou admins podem executar esta ação.

**Endpoint:** `PATCH /api/projects/:project_id/members/:id` ou `PUT /api/projects/:project_id/members/:id`

**Parâmetros de URL:**
- `project_id` (obrigatório): UUID do projeto
- `id` (obrigatório): UUID do usuário (membro)

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
  "projectMember": {
    "role": "admin"
  }
}
```

**Campos:**
- `role` (obrigatório): Novo papel do membro. Valores permitidos: `"admin"`, `"member"`, `"viewer"`

**Resposta de Sucesso (200):**
```json
{
  "projectId": "uuid-do-projeto",
  "userId": "uuid-do-usuario",
  "role": "admin",
  "joinedAt": "2026-02-26T12:00:00.000Z",
  "user": {
    "id": "uuid-do-usuario",
    "name": "Pedro Costa",
    "email": "pedro@example.com"
  },
  "project": {
    "id": "uuid-do-projeto",
    "name": "Nexus Task Manager",
    "key": "NEX"
  }
}
```

**Resposta de Erro (403):**
```json
{
  "error": "Você não tem permissão para realizar esta ação"
}
```

**Resposta de Erro (404):**
```json
{
  "error": "Membro não encontrado"
}
```

**Resposta de Erro (422):**
```json
{
  "errors": [
    "Role não está incluído na lista"
  ]
}
```

---

### 4. Remover Membro do Projeto

Remove um membro do projeto. Apenas o owner ou admins podem executar esta ação.

**Endpoint:** `DELETE /api/projects/:project_id/members/:id`

**Parâmetros de URL:**
- `project_id` (obrigatório): UUID do projeto
- `id` (obrigatório): UUID do usuário (membro)

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

**Resposta de Erro (403):**
```json
{
  "error": "Você não tem permissão para realizar esta ação"
}
```

**Resposta de Erro (404):**
```json
{
  "error": "Membro não encontrado"
}
```

---

## Validações

Os membros do projeto possuem as seguintes validações:

1. **role**: Obrigatório e deve ser um dos valores: `"admin"`, `"member"`, `"viewer"`
2. **joined_at**: Obrigatório (preenchido automaticamente no create)
3. **user_id + project_id**: Combinação única (um usuário não pode ser adicionado duas vezes ao mesmo projeto)

---

## Notas Importantes

1. **Chave Primária Composta**: A tabela usa `project_id + user_id` como chave primária composta
2. **Data de Entrada**: O campo `joined_at` é preenchido automaticamente com a data/hora atual ao adicionar um membro
3. **Permissões Hierárquicas**: Owner > Admin > Member > Viewer
4. **Dono do Projeto**: O owner não aparece automaticamente na lista de membros (a menos que seja adicionado explicitamente)
5. **Auto-remoção**: Um admin pode se remover do projeto, mas deve garantir que há outros admins ou o owner ainda tem acesso
6. **Cascade Delete**: Se um usuário for deletado, todas as suas associações como membro de projetos são removidas automaticamente
7. **Camelização**: Os campos são automaticamente convertidos de snake_case para camelCase nas respostas

---

## Exemplos com cURL

### Listar membros do projeto:
```bash
curl -X GET http://localhost:3000/api/projects/uuid-do-projeto/members \
  -H "access-token: seu-token" \
  -H "client: seu-client" \
  -H "uid: seu-email@example.com"
```

### Adicionar membro ao projeto:
```bash
curl -X POST http://localhost:3000/api/projects/uuid-do-projeto/members \
  -H "Content-Type: application/json" \
  -H "access-token: seu-token" \
  -H "client: seu-client" \
  -H "uid: seu-email@example.com" \
  -d '{
    "projectMember": {
      "userId": "uuid-do-usuario",
      "role": "member"
    }
  }'
```

### Atualizar papel do membro:
```bash
curl -X PATCH http://localhost:3000/api/projects/uuid-do-projeto/members/uuid-do-usuario \
  -H "Content-Type: application/json" \
  -H "access-token: seu-token" \
  -H "client: seu-client" \
  -H "uid: seu-email@example.com" \
  -d '{
    "projectMember": {
      "role": "admin"
    }
  }'
```

### Remover membro do projeto:
```bash
curl -X DELETE http://localhost:3000/api/projects/uuid-do-projeto/members/uuid-do-usuario \
  -H "access-token: seu-token" \
  -H "client: seu-client" \
  -H "uid: seu-email@example.com"
```

---

## Relacionamentos

### User (Usuário)
- Um **User** pode ser membro de vários **Projects** (através de **ProjectMembers**)
- Relacionamento: `has_many :project_members` e `has_many :member_projects, through: :project_members`

### Project (Projeto)
- Um **Project** pode ter vários **Users** como membros (através de **ProjectMembers**)
- Relacionamento: `has_many :project_members` e `has_many :members, through: :project_members`

### ProjectMember (Tabela Pivô)
- Conecta **User** e **Project**
- Armazena informações adicionais: `role` (permissão) e `joined_at` (data de entrada)
- Relacionamentos: `belongs_to :user` e `belongs_to :project`

---

## Estrutura da Tabela

```sql
CREATE TABLE project_members (
  project_id UUID NOT NULL,
  user_id UUID NOT NULL,
  role VARCHAR NOT NULL,
  joined_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL,
  PRIMARY KEY (project_id, user_id),
  FOREIGN KEY (project_id) REFERENCES projects(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);
```

---

## Casos de Uso

### Adicionar membro como viewer:
```json
{
  "projectMember": {
    "userId": "uuid-do-usuario",
    "role": "viewer"
  }
}
```

### Promover membro a admin:
```json
{
  "projectMember": {
    "role": "admin"
  }
}
```

### Rebaixar admin para member:
```json
{
  "projectMember": {
    "role": "member"
  }
}
```
