# API de Project Statuses (Status/Colunas do Projeto)

Este documento descreve todos os endpoints disponíveis para gerenciar os status (colunas Kanban) dos projetos na API.

## Autenticação

Todos os endpoints requerem autenticação via tokens Devise. Inclua os seguintes headers em todas as requisições:

```
access-token: {seu-access-token}
client: {seu-client}
uid: {seu-email}
```

---

## Conceitos Importantes

### Status Customizáveis

Os status são completamente customizáveis por projeto. Cada projeto pode ter seus próprios status com nomes personalizados, permitindo que equipes adaptem o workflow às suas necessidades.

### Categorias de Status

Apesar dos nomes personalizados, cada status deve ter uma **categoria** que define seu comportamento no sistema:

- **TODO**: Tarefas pendentes, não iniciadas
- **IN_PROGRESS**: Tarefas em andamento
- **DONE**: Tarefas concluídas

Esta categoria é essencial para o sistema saber se uma tarefa está concluída ou pendente, independente do nome dado ao status.

### Ordem dos Status

O campo `order` define a posição da coluna na visualização Kanban. Valores menores aparecem primeiro (0, 1, 2...).

### Status Padrão

Quando um projeto é criado, 3 status padrão são automaticamente criados:
1. **A Fazer** (order: 0, category: TODO)
2. **Em Andamento** (order: 1, category: IN_PROGRESS)
3. **Concluído** (order: 2, category: DONE)

### Proteção de Deleção

Um status não pode ser deletado se houver tarefas associadas a ele. Isso previne perda de dados.

---

## Endpoints

### 1. Listar Status do Projeto

Lista todos os status de um projeto específico, ordenados por `order`.

**Endpoint:** `GET /api/projects/:project_id/statuses`

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
    "id": "uuid-do-status-1",
    "projectId": "uuid-do-projeto",
    "name": "A Fazer",
    "order": 0,
    "category": "TODO",
    "createdAt": "2026-02-26T10:00:00.000Z",
    "updatedAt": "2026-02-26T10:00:00.000Z"
  },
  {
    "id": "uuid-do-status-2",
    "projectId": "uuid-do-projeto",
    "name": "Em Andamento",
    "order": 1,
    "category": "IN_PROGRESS",
    "createdAt": "2026-02-26T10:00:00.000Z",
    "updatedAt": "2026-02-26T10:00:00.000Z"
  },
  {
    "id": "uuid-do-status-3",
    "projectId": "uuid-do-projeto",
    "name": "Concluído",
    "order": 2,
    "category": "DONE",
    "createdAt": "2026-02-26T10:00:00.000Z",
    "updatedAt": "2026-02-26T10:00:00.000Z"
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

### 2. Criar Novo Status

Cria um novo status no projeto. Apenas owner ou admins podem executar esta ação.

**Endpoint:** `POST /api/projects/:project_id/statuses`

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
  "projectStatus": {
    "name": "Em Revisão",
    "order": 3,
    "category": "IN_PROGRESS"
  }
}
```

**Campos:**
- `name` (obrigatório): Nome do status (ex: "Em QA", "Aguardando Deploy")
- `order` (obrigatório): Posição na ordem de exibição (número inteiro ≥ 0). Deve ser único no projeto.
- `category` (obrigatório): Categoria do status. Valores permitidos: `"TODO"`, `"IN_PROGRESS"`, `"DONE"`

**Resposta de Sucesso (201):**
```json
{
  "id": "uuid-novo-status",
  "projectId": "uuid-do-projeto",
  "name": "Em Revisão",
  "order": 3,
  "category": "IN_PROGRESS",
  "createdAt": "2026-02-26T11:00:00.000Z",
  "updatedAt": "2026-02-26T11:00:00.000Z"
}
```

**Resposta de Erro (403):**
```json
{
  "error": "Você não tem permissão para gerenciar status deste projeto"
}
```

**Resposta de Erro (422):**
```json
{
  "errors": [
    "Order já está em uso",
    "Category não está incluído na lista"
  ]
}
```

---

### 3. Atualizar Status

Atualiza um status existente. Apenas owner ou admins podem executar esta ação.

**Endpoint:** `PATCH /api/projects/:project_id/statuses/:id` ou `PUT /api/projects/:project_id/statuses/:id`

**Parâmetros de URL:**
- `project_id` (obrigatório): UUID do projeto
- `id` (obrigatório): UUID do status

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
  "projectStatus": {
    "name": "Revisão de Código",
    "order": 2
  }
}
```

**Campos (todos opcionais):**
- `name`: Novo nome do status
- `order`: Nova posição (deve ser única no projeto)
- `category`: Nova categoria (`"TODO"`, `"IN_PROGRESS"` ou `"DONE"`)

**Resposta de Sucesso (200):**
```json
{
  "id": "uuid-do-status",
  "projectId": "uuid-do-projeto",
  "name": "Revisão de Código",
  "order": 2,
  "category": "IN_PROGRESS",
  "createdAt": "2026-02-26T11:00:00.000Z",
  "updatedAt": "2026-02-26T11:30:00.000Z"
}
```

**Resposta de Erro (403):**
```json
{
  "error": "Você não tem permissão para gerenciar status deste projeto"
}
```

**Resposta de Erro (404):**
```json
{
  "error": "Status não encontrado"
}
```

**Resposta de Erro (422):**
```json
{
  "errors": [
    "Order já está em uso"
  ]
}
```

---

### 4. Deletar Status

Remove um status do projeto. Apenas owner ou admins podem executar esta ação.

**IMPORTANTE**: Um status não pode ser deletado se houver tarefas associadas a ele.

**Endpoint:** `DELETE /api/projects/:project_id/statuses/:id`

**Parâmetros de URL:**
- `project_id` (obrigatório): UUID do projeto
- `id` (obrigatório): UUID do status

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
  "error": "Você não tem permissão para gerenciar status deste projeto"
}
```

**Resposta de Erro (404):**
```json
{
  "error": "Status não encontrado"
}
```

**Resposta de Erro (422):**
```json
{
  "error": "Não é possível deletar um status que possui tarefas"
}
```

---

## Validações

Os status possuem as seguintes validações:

1. **name**: Obrigatório
2. **order**: Obrigatório, número inteiro ≥ 0, único por projeto
3. **category**: Obrigatório e deve ser um dos valores: `"TODO"`, `"IN_PROGRESS"`, `"DONE"`

---

## Notas Importantes

1. **Ordem Única**: Cada projeto deve ter ordens únicas para seus status (não pode ter dois status com order = 1)
2. **Status Padrão**: 3 status são criados automaticamente quando um projeto é criado
3. **Proteção de Deleção**: Status com tarefas associadas não podem ser deletados
4. **Permissões**: Apenas owner e admins podem criar, editar ou deletar status
5. **Categorias Fixas**: As categorias são um enum fixo (TODO, IN_PROGRESS, DONE) e não podem ser customizadas
6. **Reordenação**: Para reordenar status, atualize o campo `order` de cada status
7. **Camelização**: Os campos são automaticamente convertidos de snake_case para camelCase nas respostas

---

## Exemplos com cURL

### Listar status do projeto:
```bash
curl -X GET http://localhost:3000/api/projects/uuid-do-projeto/statuses \
  -H "access-token: seu-token" \
  -H "client: seu-client" \
  -H "uid: seu-email@example.com"
```

### Criar novo status:
```bash
curl -X POST http://localhost:3000/api/projects/uuid-do-projeto/statuses \
  -H "Content-Type: application/json" \
  -H "access-token: seu-token" \
  -H "client: seu-client" \
  -H "uid: seu-email@example.com" \
  -d '{
    "projectStatus": {
      "name": "Em QA",
      "order": 3,
      "category": "IN_PROGRESS"
    }
  }'
```

### Atualizar status:
```bash
curl -X PATCH http://localhost:3000/api/projects/uuid-do-projeto/statuses/uuid-do-status \
  -H "Content-Type: application/json" \
  -H "access-token: seu-token" \
  -H "client: seu-client" \
  -H "uid: seu-email@example.com" \
  -d '{
    "projectStatus": {
      "name": "Quality Assurance",
      "order": 2
    }
  }'
```

### Deletar status:
```bash
curl -X DELETE http://localhost:3000/api/projects/uuid-do-projeto/statuses/uuid-do-status \
  -H "access-token: seu-token" \
  -H "client: seu-client" \
  -H "uid: seu-email@example.com"
```

---

## Casos de Uso

### Workflow Simples (3 colunas):
```json
[
  {"name": "A Fazer", "order": 0, "category": "TODO"},
  {"name": "Fazendo", "order": 1, "category": "IN_PROGRESS"},
  {"name": "Feito", "order": 2, "category": "DONE"}
]
```

### Workflow Completo (7 colunas):
```json
[
  {"name": "Backlog", "order": 0, "category": "TODO"},
  {"name": "A Fazer", "order": 1, "category": "TODO"},
  {"name": "Em Desenvolvimento", "order": 2, "category": "IN_PROGRESS"},
  {"name": "Em Revisão", "order": 3, "category": "IN_PROGRESS"},
  {"name": "Em QA", "order": 4, "category": "IN_PROGRESS"},
  {"name": "Aguardando Deploy", "order": 5, "category": "IN_PROGRESS"},
  {"name": "Concluído", "order": 6, "category": "DONE"}
]
```

### Workflow Ágil com Aprovação:
```json
[
  {"name": "Product Backlog", "order": 0, "category": "TODO"},
  {"name": "Sprint Backlog", "order": 1, "category": "TODO"},
  {"name": "Em Andamento", "order": 2, "category": "IN_PROGRESS"},
  {"name": "Em Revisão", "order": 3, "category": "IN_PROGRESS"},
  {"name": "Aguardando Aprovação", "order": 4, "category": "IN_PROGRESS"},
  {"name": "Aprovado", "order": 5, "category": "DONE"},
  {"name": "Entregue", "order": 6, "category": "DONE"}
]
```

---

## Relacionamentos

### Project (Projeto)
- Um **Project** pode ter vários **ProjectStatuses**
- Relacionamento: `has_many :project_statuses, dependent: :destroy`
- Quando um projeto é deletado, todos os seus status são removidos

### ProjectStatus (Status)
- Um **ProjectStatus** pertence a um **Project**
- Um **ProjectStatus** pode ter várias **Tasks**
- Relacionamento: `belongs_to :project` e `has_many :tasks, dependent: :restrict_with_error`
- Status com tarefas não podem ser deletados (restrict_with_error)

---

## Estrutura da Tabela

```sql
CREATE TABLE project_statuses (
  id UUID PRIMARY KEY,
  project_id UUID NOT NULL,
  name VARCHAR NOT NULL,
  order INTEGER NOT NULL DEFAULT 0,
  category VARCHAR NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL,
  FOREIGN KEY (project_id) REFERENCES projects(id),
  UNIQUE (project_id, order)
);

CREATE INDEX index_project_statuses_on_project_id ON project_statuses(project_id);
CREATE UNIQUE INDEX index_project_statuses_on_project_id_and_order ON project_statuses(project_id, order);
```

---

## Scopes Disponíveis

O model ProjectStatus possui os seguintes scopes úteis:

```ruby
# Ordenar por posição
ProjectStatus.ordered

# Filtrar por categoria
ProjectStatus.todo          # category = 'TODO'
ProjectStatus.in_progress   # category = 'IN_PROGRESS'
ProjectStatus.done          # category = 'DONE'
```

## Métodos Helper

```ruby
status.done?         # true se category == 'DONE'
status.todo?         # true se category == 'TODO'
status.in_progress?  # true se category == 'IN_PROGRESS'
```
