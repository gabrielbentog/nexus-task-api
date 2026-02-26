## API de Sprints (Ciclos de Tempo)

Endpoints para gerenciar ciclos de tempo SCRUM (Sprints) de cada projeto.

### Autenticação
Todos os endpoints requerem autenticação via tokens Devise.

### Endpoints

#### Listar sprints do projeto
`GET /api/projects/:project_id/sprints`

Retorna todas as sprints do projeto.

#### Exibir sprint
`GET /api/projects/:project_id/sprints/:id`

Retorna detalhes de uma sprint específica.

#### Criar sprint
`POST /api/projects/:project_id/sprints`

Body:
```
{
  "sprint": {
    "name": "Sprint 01 - MVP",
    "goal": "Entregar MVP funcional",
    "start_date": "2026-03-01",
    "end_date": "2026-03-15",
    "status": "PLANNED"
  }
}
```

#### Atualizar sprint
`PATCH /api/projects/:project_id/sprints/:id`

Body:
```
{
  "sprint": {
    "name": "Sprint 01 - Ajustada",
    "status": "ACTIVE"
  }
}
```

#### Deletar sprint
`DELETE /api/projects/:project_id/sprints/:id`

#### Permissões
- Apenas owner ou admin podem criar, editar ou deletar sprints
- Qualquer membro pode visualizar

#### Campos importantes
- `name`: obrigatório
- `goal`: opcional
- `start_date`/`end_date`: obrigatório
- `status`: enum (PLANNED, ACTIVE, COMPLETED)
- `velocity`: opcional (calculado ao final)

#### Exemplo de resposta
```
{
  "id": "uuid-da-sprint",
  "name": "Sprint 01 - MVP",
  "goal": "Entregar MVP funcional",
  "startDate": "2026-03-01",
  "endDate": "2026-03-15",
  "status": "PLANNED",
  "velocity": null,
  "projectId": "uuid-do-projeto",
  "createdAt": "2026-02-26T12:00:00Z",
  "updatedAt": "2026-02-26T12:00:00Z"
}
```
