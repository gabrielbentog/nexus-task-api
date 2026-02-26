## API de Tags (Etiquetas)

Endpoints para gerenciar etiquetas específicas de cada projeto.

### Autenticação
Todos os endpoints requerem autenticação via tokens Devise.

### Endpoints

#### Listar tags do projeto
`GET /api/projects/:project_id/tags`

Retorna todas as tags do projeto.

#### Exibir tag
`GET /api/projects/:project_id/tags/:id`

Retorna detalhes de uma tag específica.

#### Criar tag
`POST /api/projects/:project_id/tags`

Body:
```
{
  "tag": {
    "name": "bug",
    "color": "#FF0000"
  }
}
```

#### Atualizar tag
`PATCH /api/projects/:project_id/tags/:id`

Body:
```
{
  "tag": {
    "name": "frontend",
    "color": "#00FF00"
  }
}
```

#### Deletar tag
`DELETE /api/projects/:project_id/tags/:id`

#### Permissões
- Apenas owner ou admin podem criar, editar ou deletar tags
- Qualquer membro pode visualizar

#### Campos importantes
- `name`: obrigatório, único por projeto
- `color`: obrigatório, hexadecimal (#RRGGBB)
- `project_id`: projeto ao qual pertence

#### Exemplo de resposta
```
{
  "id": "uuid-da-tag",
  "name": "bug",
  "color": "#FF0000",
  "projectId": "uuid-do-projeto",
  "createdAt": "2026-02-26T12:00:00Z",
  "updatedAt": "2026-02-26T12:00:00Z"
}
```
