## API de Relações de Bloqueio (TaskDependency)

Permite criar relações entre tarefas para dependências e bloqueios na timeline.

### Autenticação
Todos os endpoints requerem autenticação via tokens Devise.

### Endpoints

#### Listar dependências de uma tarefa
`GET /api/tasks/:task_id/dependencies`

Retorna todas as dependências onde a tarefa é bloqueada ou bloqueadora.

#### Criar dependência
`POST /api/tasks/:task_id/dependencies`

Body:
```
{
  "task_dependency": {
    "blocker_task_id": "uuid-da-tarefa-bloqueadora",
    "relation_type": "blocks"
  }
}
```

#### Deletar dependência
`DELETE /api/tasks/:task_id/dependencies/:id`

#### Campos importantes
- `blocked_task_id`: Tarefa bloqueada (não pode começar)
- `blocker_task_id`: Tarefa bloqueadora (precisa terminar antes)
- `relation_type`: Tipo da relação (blocks, requires, relates_to)

#### Exemplo de resposta
```
{
  "id": "uuid-da-dependencia",
  "blockedTaskId": "uuid-tarefa-bloqueada",
  "blockerTaskId": "uuid-tarefa-bloqueadora",
  "relationType": "blocks",
  "createdAt": "2026-02-26T12:00:00Z",
  "updatedAt": "2026-02-26T12:00:00Z"
}
```
