#### Tags em tarefas
Cada tarefa pode ter várias tags (etiquetas) associadas.

Para associar tags a uma tarefa, envie um array de IDs de tags no campo `tag_ids` ao criar ou atualizar:

```
{
  "task": {
    "title": "Corrigir bug",
    "priority": "HIGH",
    "status_id": "uuid-do-status",
    "tag_ids": ["uuid-tag-bug", "uuid-tag-frontend"]
  }
}
```

No JSON de resposta, o campo `tags` trará as etiquetas associadas à tarefa.

#### Exemplo de resposta com tags
```
{
  "id": "uuid-da-tarefa",
  ...,
  "tags": [
    { "id": "uuid-tag-bug", "name": "bug", "color": "#FF0000" },
    { "id": "uuid-tag-frontend", "name": "frontend", "color": "#00FF00" }
  ]
}
```
#### Quadro Kanban
`GET /api/projects/:project_id/tasks/kanban`

Retorna as tarefas agrupadas por status (colunas do Kanban).

Exemplo de resposta:
```
[
  {
    "status": {
      "id": "uuid-do-status",
      "name": "A Fazer",
      "order": 0,
      "category": "TODO"
    },
    "tasks": [
      { "id": "uuid-da-tarefa", "title": "Tarefa 1", ... },
      ...
    ]
  },
  ...
]
```

Permissões: qualquer membro do projeto pode acessar.
## API de Tasks (Tarefas)

Endpoints para gerenciar tarefas de um projeto.

### Autenticação
Todos os endpoints requerem autenticação via tokens Devise.

### Endpoints

#### Listar tarefas
`GET /api/projects/:project_id/tasks`

Retorna todas as tarefas do projeto, ordenadas pelo display_id.

#### Exibir tarefa
`GET /api/projects/:project_id/tasks/:id`

Retorna detalhes de uma tarefa específica.

#### Criar tarefa
`POST /api/projects/:project_id/tasks`

Body:
```
{
  "task": {
    "title": "Nova tarefa",
    "description": "Descrição opcional",
    "priority": "HIGH",
    "status_id": "uuid-do-status",
    "assignee_id": "uuid-do-usuario",
    "parent_id": "uuid-da-tarefa-pai",
    "due_date": "2026-03-01T12:00:00Z"
  }
}
```

#### Atualizar tarefa
`PATCH /api/projects/:project_id/tasks/:id`

Body:
```
{
  "task": {
    "title": "Título atualizado",
    "priority": "MEDIUM"
  }
}
```

#### Deletar tarefa
`DELETE /api/projects/:project_id/tasks/:id`

#### Permissões
- Apenas owner ou admin podem criar, editar ou deletar tarefas
- Qualquer membro pode visualizar

#### Campos importantes
- `code`: Código único da tarefa (ex: NEX-1)
- `display_id`: Sequencial por projeto
- `priority`: Enum (LOW, MEDIUM, HIGH, URGENT)
- `status_id`: FK para ProjectStatus
- `assignee_id`: FK para User
- `parent_id`: FK para Task (subtarefas)
- `due_date`: Data de vencimento

#### Exemplo de resposta
```
{
  "id": "uuid-da-tarefa",
  "code": "NEX-1",
  "displayId": 1,
  "title": "Primeira tarefa do projeto Nexus Task Manager",
  "description": "Descrição inicial",
  "priority": "MEDIUM",
  "dueDate": "2026-03-01T12:00:00Z",
  "status": {
    "id": "uuid-do-status",
    "name": "A Fazer",
    "category": "TODO"
  },
  "assignee": {
    "id": "uuid-do-usuario",
    "name": "João Silva"
  },
  "createdAt": "2026-02-26T10:00:00Z",
  "updatedAt": "2026-02-26T10:00:00Z"
}
```

#### Validações
- `title`: obrigatório
- `priority`: obrigatório, enum
- `display_id`: auto-incremento por projeto

#### Relacionamentos
- belongs_to :project
- belongs_to :status (ProjectStatus)
- belongs_to :assignee (User, opcional)
- belongs_to :parent (Task, opcional)
- has_many :subtasks

#### Exemplos cURL
```bash
curl -X POST http://localhost:3000/api/projects/uuid-do-projeto/tasks \
  -H "Content-Type: application/json" \
  -H "access-token: seu-token" \
  -H "client: seu-client" \
  -H "uid: seu-email@example.com" \
  -d '{
    "task": {
      "title": "Nova tarefa",
      "priority": "HIGH",
      "status_id": "uuid-do-status"
    }
  }'
```
