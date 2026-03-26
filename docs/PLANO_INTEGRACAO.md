# Plano de Integração Flutter ↔ SosApi

> **Data da análise inicial:** 2026-03-26  
> **Última validação:** 2026-03-26  
> **Status geral:** Fase 1 concluída, Fase 4 concluída e Fase 5 concluída no app Flutter; restam validações operacionais complementares fora do núcleo da integração

> **Regra de qualidade:** este projeto trabalha obrigatoriamente com TDD. Toda correção ou evolução deve preservar a suíte automatizada totalmente funcional, e nenhum item é considerado concluído sem `flutter test` 100% verde.

---

## Diagnóstico Geral

O app GuinchoApp está **completo em 8 sprints** com Clean Architecture robusta, offline-first e todas as camadas implementadas. O backend SosApi está igualmente completo com 425 testes, CQRS, JWT, e Swagger documentado.

**O problema:** os dois projetos foram desenvolvidos em paralelo e ainda exigem validações operacionais pontuais, mas o núcleo da integração ponta a ponta foi alinhado. A fundação de rede/serialização da Fase 1 foi concluída, o contrato de `AtendimentoDto` está validado, a conclusão `PorKm` passa a preencher `distanciaRealKm`/`valorCobrado` antes do `PATCH`, os fluxos de PATCH/status, batch de rastreamento e pull sync já estão alinhados ao backend, e auth/dashboard passaram a consumir os contratos remotos confirmados.

---

## Gaps por Severidade

### 🔴 BLOQUEANTES — App quebra em runtime

| #   | Gap                                                             | Flutter                                                                                                            | Backend                                                                                             | Impacto                                  |
| --- | --------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------- | ---------------------------------------- |
| 1   | **baseUrl configurada de forma inconsistente**                  | Resolvido: `NetworkModule` agora injeta `Dio` já configurado com `baseUrl`, headers e interceptors                 | Endpoints reais                                                                                     | Item concluído na Fase 1                 |
| 2   | **Porta dev errada**                                            | Resolvido no `AppConfig` atual                                                                                     | Backend exposto via URL com `/api`                                                                  | Item concluído na Fase 1                 |
| 3   | **Prefixo `/api/` dependente da inicialização do cliente HTTP** | Resolvido: os datasources continuam com paths relativos, mas o `Dio` injetado já sai com `/api` na base            | Backend responde em `/api/auth/login`, `/api/clientes`...                                           | Item concluído na Fase 1                 |
| 4   | **LoginResponse — estrutura JSON incompatível**                 | Resolvido conforme `BACKEND_GUIDE`: `AuthRemoteDatasourceImpl` parseia `{ token, usuario }`                        | `BACKEND_GUIDE` documenta `LoginResponse(string Token, UsuarioDto Usuario)`                         | Item validado como alinhado no workspace |
| 5   | **UsuarioModel.fromJson — campos errados**                      | Resolvido para o contrato camelCase atual do app/backend                                                           | Backend retorna camelCase nos DTOs documentados                                                     | Item concluído no workspace              |
| 6   | **Convenção JSON: snake_case vs camelCase**                     | Resolvido nos models principais com serialização e leitura em camelCase                                            | Backend serializa em camelCase (`clienteId`, `criadoEm`, `distanciaEstimadaKm`)                     | Item concluído na Fase 1                 |
| 7   | **Enum Status/TipoValor no AtendimentoDto**                     | Resolvido: Flutter serializa e desserializa enums de atendimento em PascalCase (`Rascunho`, `PorKm`)               | Validado: `AtendimentoMapper.ToDto(...)` usa `a.TipoValor.ToString()` e `a.Status.ToString()`       | Item concluído na Fase 3                 |
| 8   | **GET /clientes — esperando List, recebe PagedResult**          | Resolvido: `ClienteRemoteDatasourceImpl` agora parseia `PagedResult` e expõe `items`                               | Retorna `{items:[], page:1, totalCount:...}`                                                        | Item concluído na Fase 3                 |
| 9   | **GET /atendimentos — mesmo problema de paginação**             | Resolvido: `AtendimentoRemoteDatasourceImpl` agora parseia `PagedResult` e expõe `items`                           | Retorna `PagedResult<AtendimentoDto>`                                                               | Item concluído na Fase 3                 |
| 10  | **Transição de status usa PUT, backend requer PATCH**           | Resolvido: `status_update` agora sincroniza via `PATCH /atendimentos/{id}/status`                                  | Contrato confirmado: `{novoStatus, atualizadoEm, distanciaRealKm?, valorCobrado?}`                  | Item concluído na Fase 3                 |
| 11  | **Base.definirPrincipal: PUT → POST**                           | Resolvido: `BaseRemoteDatasourceImpl` usa `POST /bases/{id}/principal`                                             | `POST /api/bases/{id}/principal`                                                                    | Item concluído na Fase 3                 |
| 12  | **RastreamentoRemoteDatasource não implementado**               | Resolvido: criado datasource remoto com `POST /rastreamento/pontos` e `GET /rastreamento/{atendimentoId}` paginado | Contrato confirmado: `POST /api/rastreamento/pontos` com `RegistrarPontosRequest { pontos: [...] }` | Item concluído na Fase 4                 |
| 13  | **SyncManager endpoint rastreamento errado**                    | Resolvido: `SyncManager` agrupa pontos pendentes e envia batch para `/rastreamento/pontos`                         | Backend confirma `POST /api/rastreamento/pontos` em batch e resposta `{ inseridos, total }`         | Item concluído na Fase 4                 |

### 🟡 IMPORTANTES — Funcionalidade incompleta

| #   | Gap                                          | Detalhe                                                                                                                                                                              |
| --- | -------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 14  | **Sem interceptor de refresh de token**      | Resolvido: `AuthInterceptor` agora trata `401`, chama `POST /api/auth/refresh` com Bearer atual, persiste o novo token e repete a requisição original uma vez.                       |
| 15  | **Sem sincronização pull (servidor → app)**  | Resolvido: `SyncManager` agora chama `GET /api/sync/pull?desde=` com cursor persistido e faz merge local preservando entidades ainda pendentes na fila.                              |
| 16  | **Dashboard usa apenas banco local**         | Resolvido: `DashboardRepository` agora usa endpoints remotos (`/resumo`, `/clientes`, `/etapas`, `/diario`) quando online e mantém fallback local quando offline ou em falha remota. |
| 17  | **LocalGeo: naming snake_case vs camelCase** | Resolvido nos models principais: serialização e leitura usam `enderecoTexto`.                                                                                                        |

### 🟢 MELHORIAS — Nice-to-have

| #   | Gap                               | Detalhe                                                                                                                    |
| --- | --------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| 18  | **HTTPS/cleartext no Android**    | HTTP cleartext pode ser bloqueado no Android ≥9. Precisa `android:usesCleartextTraffic=true` para dev ou configurar HTTPS. |
| 19  | **Seed: verificar usuário admin** | Confirmar senha do `admin@guinchoapp.com` no `SeedData.cs` para teste end-to-end.                                          |

---

## Mapa de Endpoints: Flutter → Backend

| Flutter (atual)              | Backend (real)                                                                  | Status                                                                                                     |
| ---------------------------- | ------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| `POST /auth/login`           | `POST /api/auth/login`                                                          | ✅ App alinhado ao `LoginResponse` flat (`token`, `usuarioId`, `nome`, `email`, `role`, `expiresAt`)       |
| `GET /auth/me`               | `GET /api/auth/me`                                                              | ✅ App alinhado ao `UsuarioAtualResponse` flat (`usuarioId`, `nome`, `email`, `role`, `valorPorKmDefault`) |
| `POST /clientes`             | `POST /api/clientes`                                                            | ✅ Prefixo e casing corrigidos                                                                             |
| `GET /clientes?q=`           | `GET /api/clientes?q=`                                                          | ✅ Prefixo/casing ok; PagedResult tratado no datasource                                                    |
| `GET /clientes/{id}`         | `GET /api/clientes/{id}`                                                        | ✅ Prefixo e casing corrigidos                                                                             |
| `PUT /clientes/{id}`         | `PUT /api/clientes/{id}`                                                        | ✅ Prefixo e casing corrigidos                                                                             |
| `POST /bases`                | `POST /api/bases`                                                               | ⚠️ Prefixo e casing ok; endpoint segue AdminOnly                                                           |
| `GET /bases`                 | `GET /api/bases`                                                                | ✅ Prefixo e casing corrigidos                                                                             |
| `POST /bases/{id}/principal` | `POST /api/bases/{id}/principal`                                                | ✅ Método HTTP alinhado                                                                                    |
| `POST /atendimentos`         | `POST /api/atendimentos`                                                        | ✅ Prefixo ok; request/response de enums alinhados                                                         |
| `GET /atendimentos`          | `GET /api/atendimentos`                                                         | ✅ Prefixo/casing ok; PagedResult tratado no datasource                                                    |
| `PUT /atendimentos/{id}`     | `PUT /api/atendimentos/{id}` (rascunho) + `PATCH /api/atendimentos/{id}/status` | ✅ PATCH de status implementado via sync                                                                   |
| `POST /pontos-rastreamento`  | `POST /api/rastreamento/pontos`                                                 | ✅ Sync ajustado para batch em `/rastreamento/pontos`                                                      |
| ❌ não existe                | `GET /api/rastreamento/{atendimentoId}`                                         | ❌ Não implementado                                                                                        |
| `GET /sync/pull?desde=`      | `GET /api/sync/pull?desde=`                                                     | ✅ Pull sync implementado com cursor persistido e merge local                                              |
| `POST /auth/refresh`         | `POST /api/auth/refresh`                                                        | ✅ Refresh automático implementado após `401`                                                              |
| `GET /dashboard/*`           | `GET /api/dashboard/*`                                                          | ✅ Dashboard remoto integrado com fallback local                                                           |

---

## Sequência Recomendada de Implementação

## Critério de Aceite Contínuo

- Toda mudança deve nascer ou ser ajustada a partir de teste primeiro, seguindo Red → Green → Refactor.
- Toda entrega só pode ser encerrada com `flutter test` totalmente verde.
- Testes quebrados são regressão de processo e devem ser tratados com prioridade imediata.

### Fase 1 — Fundação (sem isto nada funciona)

**Validação em 2026-03-25:** Fase 1 **concluída** (`4/4` itens fechados).

1. `[concluído]` `net-port-dev` — `AppConfig` não usa mais a porta antiga `10.0.2.2:3000`; os flavors apontam para URLs já com `/api`.
2. `[concluído]` `net-baseurl` — `NetworkModule` agora injeta `Dio` já configurado com `baseUrl`, headers e interceptors, eliminando dependência implícita de inicialização lateral.
3. `[concluído]` `json-casing` — `usuario_model.dart`, `cliente_model.dart`, `base_model.dart` e `atendimento_model.dart` passaram a serializar e desserializar diretamente em camelCase para campos e objetos.
4. `[concluído]` `status-casing` — backend parseia entrada com `Enum.TryParse(..., ignoreCase: true)` e responde em PascalCase via `AtendimentoMapper.ToDto(...)`, alinhado ao app.

**Conclusão da validação:** a Fase 1 segue concluída para baseUrl, casing de campos e casing de enums de atendimento.

### Fase 2 — Auth (parcialmente validada)

5. `[concluído]` `auth-login-dto` — backend real confirmado com `LoginResponse` flat; app ajustado para consumir `token`, `usuarioId`, `nome`, `email`, `role`, `expiresAt`
6. `[concluído]` `auth-me-payload` — app ajustado para consumir `UsuarioAtualResponse` flat em `GET /auth/me`
7. `[concluído]` `token-refresh` — interceptor de 401 com retry + refresh via `POST /auth/refresh`

### Fase 3 — CRUD Core (parcialmente validada)

8. `[concluído]` `atendimento-field-names` — `AtendimentoModel` já opera em camelCase
9. `[concluído]` `localGeo-naming` — `LocalGeo` já serializa e desserializa com `enderecoTexto`
10. `[concluído]` `paged-clientes` — criado `PagedResult` genérico e corrigido `ClienteRemoteDatasourceImpl`
11. `[concluído]` `paged-atendimentos` — `AtendimentoRemoteDatasourceImpl` também passou a consumir `PagedResult`
12. `[concluído]` `atendimento-status-enum-contract` — `AtendimentoMapper.ToDto(...)` retorna `status` e `tipoValor` em PascalCase, alinhado ao app
13. `[concluído]` `atendimento-status-patch` — `atualizarStatus()` agora enfileira `status_update`, sincronizado via `PATCH /atendimentos/{id}/status`
14. `[concluído]` `base-principal-method` — `definirPrincipal()` remoto usa `POST`

### Fase 4 — Rastreamento & Sync

14. `[concluído]` `rastreamento-impl` — criado `RastreamentoRemoteDatasourceImpl` para `POST /rastreamento/pontos` e `GET /rastreamento/{atendimentoId}` paginado
15. `[concluído]` `sync-endpoints` — `SyncManager` corrigido para usar `/rastreamento/pontos` em batch e manter `PATCH` de status
16. `[concluído]` `pull-sync` — `SyncManager` implementa download sync via `GET /sync/pull?desde=` com cursor persistido e merge local

### Fase 5 — Melhorias

17. `[concluído]` `dashboard-remote` — dashboard integrado com API e fallback local
18. `cors-ssl` — configurar Android cleartext / HTTPS
19. `seed-usuario` — testar login end-to-end

---

## Decisão Arquitetural Chave: JSON Casing

**Decisão consolidada:** o app Flutter passa a trabalhar diretamente em camelCase, alinhado aos DTOs documentados no workspace.

- `usuario_model.dart`, `cliente_model.dart`, `base_model.dart` e `atendimento_model.dart` serializam e desserializam em camelCase
- `LocalGeo` usa `enderecoTexto`
- A compatibilidade legada em snake_case foi removida por não haver necessidade real no projeto atual

---

## Decisão Arquitetural: baseUrl com prefixo `/api`

**Decisão consolidada:** o `Dio` injetado sai configurado com `baseUrl` completo, incluindo `/api`.

```dart
// network_module.dart
@singleton
Dio dio(...) => configureDio(...);

// app_config.dart — dev
apiBaseUrl: 'https://.../api'
```

- Nenhum datasource precisa mudar os paths relativos

---

## Contrato de DTOs — Diferenças Críticas

### LoginResponse

```json
{
  "token": "eyJ...",
  "usuarioId": "uuid",
  "nome": "string",
  "email": "string",
  "role": "operador",
  "expiresAt": "2026-..."
}
```

- Esse shape foi confirmado no `AuthController` real e o app foi alinhado ao contrato flat.

### UsuarioAtualResponse

```json
{
  "usuarioId": "uuid",
  "nome": "string",
  "email": "string",
  "role": "operador",
  "valorPorKmDefault": 5.0
}
```

- Esse shape foi confirmado no `GET /api/auth/me` real e agora é o contrato usado pelo app.

### AtendimentoStatus (Enum Casing)

**Atualização de validação em 2026-03-26:**

- o backend confirmou `Enum.TryParse(..., ignoreCase: true)` em `CriarAtendimentoCommand` e `AtualizarStatusCommand`, então o casing de entrada está tolerante
- `CriarAtendimentoCommand` força `Status = Rascunho` no servidor ao criar um atendimento
- `AtendimentoMapper.ToDto(...)` usa `a.TipoValor.ToString()` e `a.Status.ToString()`, então a resposta segue PascalCase e fica alinhada ao app

Com isso, os enums de atendimento ficam validados tanto na escrita quanto na leitura.

---

## Estimativa de Esforço

| Fase                       | Itens  | Complexidade | Estimativa  |
| -------------------------- | ------ | ------------ | ----------- |
| Fase 1 — Fundação          | 4      | Baixa        | 2-4h        |
| Fase 2 — Auth              | 3      | Média        | 3-5h        |
| Fase 3 — CRUD Core         | 6      | Média/Alta   | 8-12h       |
| Fase 4 — Rastreamento/Sync | 3      | Alta         | 6-10h       |
| Fase 5 — Melhorias         | 3      | Baixa/Média  | 4-6h        |
| **Total**                  | **19** |              | **~23-37h** |
