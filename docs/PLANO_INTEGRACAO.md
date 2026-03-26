# Plano de Integração Flutter ↔ SosApi

> **Papel:** Arquiteto de Software Senior  
> **Análise inicial:** 2026-03-26  
> **Última atualização:** 2026-03-26

---

## 📊 Progresso Geral

| Fase | Total | ✅ Concluído | 🔄 Em andamento | ⏳ Pendente |
|------|-------|-------------|-----------------|------------|
| Fase 1 — Fundação | 4 | 4 | 0 | 0 |
| Fase 2 — Auth | 3 | 0 | 0 | 3 |
| Fase 3 — CRUD Core | 6 | 0 | 0 | 6 |
| Fase 4 — Rastreamento/Sync | 3 | 0 | 0 | 3 |
| Fase 5 — Melhorias | 3 | 0 | 0 | 3 |
| **TOTAL** | **19** | **4** | **0** | **15** |

---

## Diagnóstico Geral

O app GuinchoApp está **completo em 8 sprints** (345 testes, 0 issues de lint) com Clean Architecture robusta, offline-first e todas as camadas implementadas. O backend SosApi está igualmente completo com 425 testes, CQRS, JWT, e Swagger documentado.

**O problema:** os dois projetos foram desenvolvidos em paralelo e há desalinhamento de contrato de API em múltiplas camadas.

**URL da API publicada:** `https://burghal-klara-nonextraneously.ngrok-free.dev`

---

## Gaps por Severidade

### 🔴 BLOQUEANTES — App quebra em runtime

| # | Gap | Status | Flutter | Backend | Impacto |
|---|-----|--------|---------|---------|---------|
| 1 | **baseUrl nunca configurado no Dio** | ✅ Resolvido | `NetworkModule` criava `Dio()` sem baseUrl | Endpoints reais | 100% das chamadas HTTP falhariam |
| 2 | **Porta dev errada / URL incorreta** | ✅ Resolvido | `http://10.0.2.2:3000` → ngrok URL com `/api` | .NET em `5000/7000` | Conexão recusada |
| 3 | **Prefixo `/api/` ausente em todos os endpoints** | ✅ Resolvido | `/auth/login`, `/clientes`... | `/api/auth/login`... | HTTP 404 em toda chamada |
| 4 | **LoginResponse — estrutura JSON incompatível** | ⏳ Pendente | Parseia `data['usuario']` (objeto aninhado) | Retorna flat: `{token, usuarioId, nome, email, role, expiresAt}` | `NullPointerException` ao fazer login |
| 5 | **UsuarioModel.fromJson — campos errados** | ⏳ Pendente | Lê `json['id']`, `json['telefone']`, `json['valor_por_km_default']` | Retorna `usuarioId`, sem `telefone`, `valorPorKmDefault` | Parse falha no login e no GET /me |
| 6 | **Convenção JSON: snake_case vs camelCase** | ⏳ Pendente (Fase 3) | snake_case: `cliente_id`, `criado_em`... | camelCase: `clienteId`, `criadoEm`... | Campos `null` após parse |
| 7 | **Enum Status/TipoValor: casing incorreto** | ✅ Resolvido | `.name` retornava `"emDeslocamento"`, `"porKm"` | `"EmDeslocamento"`, `"PorKm"` (PascalCase) | `ArgumentError` no parse |
| 8 | **GET /clientes — esperando List, recebe PagedResult** | ⏳ Pendente | `_dio.get<List<dynamic>>('/clientes')` | `{items:[], page:1, totalCount:...}` | `CastError` ao buscar clientes |
| 9 | **GET /atendimentos — mesmo problema de paginação** | ⏳ Pendente | `response.data as List` | `PagedResult<AtendimentoDto>` | `CastError` ao listar atendimentos |
| 10 | **Transição de status usa PUT, backend requer PATCH** | ⏳ Pendente | `PUT /atendimentos/{id}` completo | `PATCH /api/atendimentos/{id}/status` | Transições ignoradas/rejeitadas |
| 11 | **Base.definirPrincipal: PUT → POST** | ⏳ Pendente | `_dio.put('/bases/$id/principal')` | `POST /api/bases/{id}/principal` | HTTP 405 Method Not Allowed |
| 12 | **RastreamentoRemoteDatasource não implementado** | ⏳ Pendente | Arquivo `.gitkeep` — sem impl | `POST /api/rastreamento/pontos` existe | GPS nunca sincroniza |
| 13 | **SyncManager endpoint rastreamento errado** | ⏳ Pendente | `POST /pontos-rastreamento` (individual) | `POST /api/rastreamento/pontos` com `{pontos:[...]}` (batch) | Sync falha com 404 |

### 🟡 IMPORTANTES — Funcionalidade incompleta

| # | Gap | Status | Detalhe |
|---|-----|--------|---------|
| 14 | **Sem interceptor de refresh de token** | ⏳ Pendente | Backend tem `POST /api/auth/refresh`. Sem interceptor de 401. |
| 15 | **Sem sincronização pull (servidor → app)** | ⏳ Pendente | `GET /api/sync/pull?desde=` existe no backend. Dados de outros dispositivos nunca chegam ao app. |
| 16 | **Dashboard usa apenas banco local** | ⏳ Pendente | Endpoints `/api/dashboard/*` existem. Flutter lê só do Drift. |
| 17 | **LocalGeo: naming snake_case vs camelCase** | ⏳ Pendente (Fase 3) | `endereco_texto` → `enderecoTexto`. Coordenadas ficam null. |

### 🟢 MELHORIAS — Nice-to-have

| # | Gap | Status | Detalhe |
|---|-----|--------|---------|
| 18 | **HTTPS/cleartext no Android** | ⏳ Pendente | ngrok já usa HTTPS — risco mitigado. Para dev local futuramente: `android:usesCleartextTraffic=true`. |
| 19 | **Seed: verificar usuário admin** | ⏳ Pendente | Confirmar senha do `admin@guinchoapp.com` no `SeedData.cs`. |

---

## Mapa de Endpoints: Flutter → Backend

| Flutter | Backend | Status |
|---------|---------|--------|
| `POST /auth/login` | `POST /api/auth/login` | ⚠️ Prefixo ✅ · Body shape ⏳ |
| `GET /auth/me` | `GET /api/auth/me` | ⚠️ Prefixo ✅ · Field names ⏳ |
| `POST /clientes` | `POST /api/clientes` | ⚠️ Prefixo ✅ · Casing ⏳ |
| `GET /clientes?q=` | `GET /api/clientes?q=` | ⚠️ Prefixo ✅ · PagedResult ⏳ |
| `GET /clientes/{id}` | `GET /api/clientes/{id}` | ⚠️ Prefixo ✅ · Casing ⏳ |
| `PUT /clientes/{id}` | `PUT /api/clientes/{id}` | ⚠️ Prefixo ✅ · Casing ⏳ |
| `POST /bases` | `POST /api/bases` | ⚠️ Prefixo ✅ · AdminOnly ⏳ |
| `GET /bases` | `GET /api/bases` | ✅ Prefixo ✅ |
| `PUT /bases/{id}/principal` | `POST /api/bases/{id}/principal` | ⚠️ Prefixo ✅ · Método HTTP ⏳ |
| `POST /atendimentos` | `POST /api/atendimentos` | ⚠️ Prefixo ✅ · Casing ⏳ |
| `GET /atendimentos` | `GET /api/atendimentos` | ⚠️ Prefixo ✅ · PagedResult ⏳ |
| `PUT /atendimentos/{id}` | `PUT /api/atendimentos/{id}` + `PATCH /api/atendimentos/{id}/status` | ⚠️ Prefixo ✅ · PATCH status ⏳ |
| `POST /pontos-rastreamento` | `POST /api/rastreamento/pontos` | ⏳ Path errado + batch ⏳ |
| ❌ não existe | `GET /api/rastreamento/{atendimentoId}` | ⏳ Não implementado |
| ❌ não existe | `GET /api/sync/pull?desde=` | ⏳ Não implementado |
| ❌ não existe | `POST /api/auth/refresh` | ⏳ Não implementado |
| ❌ não existe | `GET /api/dashboard/*` | ⏳ Não integrado |

---

## Roadmap de Implementação

### ✅ Fase 1 — Fundação (concluída em 2026-03-26)

| # | Item | Arquivo(s) | Detalhe |
|---|------|-----------|---------|
| 1 | ~~`net-port-dev`~~ | `app_config.dart` | dev/staging → `https://burghal-klara-nonextraneously.ngrok-free.dev/api`; prod → `https://api.guinchoapp.com.br/api` |
| 2 | ~~`net-baseurl`~~ | `http_client.dart` | `BaseOptions` agora inclui `baseUrl: AppConfig.instance.apiBaseUrl` |
| 3 | ~~`json-casing`~~ | — | Decisão tomada: **Opção B** — atualizar modelos Flutter para camelCase (implementado na Fase 3) |
| 4 | ~~`status-casing`~~ | `atendimento_enums.dart`, `atendimento_model.dart` | Extensions `toApiValue()`, `toAtendimentoStatus()`, `toTipoValor()`; model armazena camelCase, envia PascalCase |

### ⏳ Fase 2 — Auth

| # | Item | Arquivo(s) | O que fazer |
|---|------|-----------|-------------|
| 5 | `auth-login-dto` | `auth_remote_datasource_impl.dart` | Parsear resposta flat `{token, usuarioId, nome, email, role, expiresAt}` |
| 6 | `auth-me-dto` | `usuario_model.dart` | Mapear `usuarioId→id`, `valorPorKmDefault` camelCase, remover `telefone` obrigatório |
| 7 | `token-refresh` | `http_client.dart` | Interceptor de 401: chama `POST /api/auth/refresh`, salva novo token, retenta request |

### ⏳ Fase 3 — CRUD Core

| # | Item | Arquivo(s) | O que fazer |
|---|------|-----------|-------------|
| 8 | `atendimento-field-names` | `atendimento_model.dart` | snake_case → camelCase em todos os campos JSON |
| 9 | `localGeo-naming` | `atendimento_model.dart` | `endereco_texto` → `enderecoTexto` em `_encodeLocalGeo` / `_decodeLocalGeo` |
| 10 | `paged-clientes` | `cliente_remote_datasource_impl.dart` | Criar `PagedResult<T>`, extrair `items` da resposta paginada |
| 11 | `paged-atendimentos` | `atendimento_remote_datasource_impl.dart` | Mesmo padrão de paginação |
| 12 | `atendimento-status-patch` | `atendimento_remote_datasource.dart` + impl | Novo método `atualizarStatus()` com `PATCH /api/atendimentos/{id}/status` |
| 13 | `base-principal-method` | `base_remote_datasource_impl.dart` | `_dio.put` → `_dio.post` em `definirPrincipal()` |

### ⏳ Fase 4 — Rastreamento & Sync

| # | Item | Arquivo(s) | O que fazer |
|---|------|-----------|-------------|
| 14 | `rastreamento-impl` | `rastreamento_remote_datasource_impl.dart` *(novo)* | `enviarPontos()` → `POST /api/rastreamento/pontos` com `{pontos:[...]}`; `obterPontos()` → `GET /api/rastreamento/{id}` |
| 15 | `sync-endpoints` | `sync_manager.dart` | `_enviarPontoRastreamento()`: path e estrutura batch corretos; registrar no DI |
| 16 | `pull-sync` | `sync_manager.dart` *(ou novo serviço)* | `GET /api/sync/pull?desde=` após cada push; persistir clientes/atendimentos/bases no Drift |

### ⏳ Fase 5 — Melhorias

| # | Item | Arquivo(s) | O que fazer |
|---|------|-----------|-------------|
| 17 | `dashboard-remote` | `dashboard_remote_datasource.dart` *(novo)* | Integrar `/api/dashboard/*`; exibir remoto se online, local se offline |
| 18 | `cors-ssl` | `AndroidManifest.xml` | ngrok já é HTTPS — verificar para dev local futuro |
| 19 | `seed-usuario` | — | Testar login E2E com `admin@guinchoapp.com` via Swagger ou app |

---

## Decisões Arquiteturais

### JSON Casing — Decisão: Opção B ✅

Atualizar os modelos Flutter para camelCase (Fase 3), mantendo o backend intacto.  
Razão: API já publicada via ngrok; mudança no backend quebraria compatibilidade.

### baseUrl — Decisão: baseUrl no HttpClient ✅

`HttpClient` seta `baseUrl` via `AppConfig.instance.apiBaseUrl` no `BaseOptions`.  
Nenhum datasource precisa incluir prefixo nos paths relativos.

---

## Contrato de DTOs — Diferenças Críticas

### LoginResponse (Gap #4 — ⏳ Fase 2)

```
Backend retorna (flat):          Flutter espera (aninhado):
{                                {
  "token": "eyJ...",               "token": "eyJ...",
  "usuarioId": "uuid",             "usuario": {           ← NÃO EXISTE
  "nome": "string",                  "id": "uuid",
  "email": "string",                 "nome": "string",
  "role": "Operador",                "telefone": "...",   ← NÃO EXISTE no login
  "expiresAt": "2026-..."            ...
}                                  }
                                 }
```

### AtendimentoStatus (Gap #7 — ✅ Resolvido)

| Flutter `.name` | API envia/recebe | Conversor |
|-----------------|-----------------|-----------|
| `emDeslocamento` | `EmDeslocamento` | `toApiValue()` / `toAtendimentoStatus()` |
| `porKm` | `PorKm` | `toApiValue()` / `toTipoValor()` |

---

## Estimativa de Esforço

| Fase | Itens | Status | Estimativa |
|------|-------|--------|------------|
| Fase 1 — Fundação | 4 | ✅ Concluída | — |
| Fase 2 — Auth | 3 | ⏳ Pendente | 3-5h |
| Fase 3 — CRUD Core | 6 | ⏳ Pendente | 8-12h |
| Fase 4 — Rastreamento/Sync | 3 | ⏳ Pendente | 6-10h |
| Fase 5 — Melhorias | 3 | ⏳ Pendente | 4-6h |
| **Restante** | **15** | | **~21-33h** |

