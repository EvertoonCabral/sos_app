# GuinchoApp — App de Gestão de Viaturas de Socorro

App Flutter offline-first para gestão de atendimentos de guincho com rastreamento GPS e relatórios de produtividade.

## Visão Geral

- **Plataforma:** Flutter (Android e iOS)
- **Arquitetura:** Clean Architecture (feature-first) com BLoC/Cubit
- **Banco local:** Drift (SQLite) — 7 tabelas, 6 índices
- **DI:** GetIt + Injectable
- **HTTP:** Dio com interceptors (auth, retry, logging)
- **Testes:** 345 testes unitários e de widget (mocktail + bloc_test)
- **Análise:** `dart analyze` — 0 issues

## Funcionalidades

| Feature | Descrição |
|---------|-----------|
| **Autenticação** | Login com token JWT via API REST |
| **Clientes** | CRUD offline-first com busca |
| **Bases/Garagens** | Gestão de pontos de saída com base principal |
| **Atendimentos** | Ciclo completo: rascunho → deslocamento → coleta → entrega → retorno → concluído |
| **Rastreamento GPS** | Coleta em background a cada 30s/100m com stream |
| **Sincronização** | Queue com backoff exponencial e monitoramento de conectividade |
| **Dashboard** | Métricas (KM operacional/cobrado, receita), gráficos, ranking de clientes, tempo por etapa |

## Estrutura do Projeto

```
lib/
├── main.dart
├── core/
│   ├── constants/       # AppConstants, AppConfig (flavors)
│   ├── database/        # Drift tables + AppDatabase
│   ├── di/              # GetIt + Injectable modules
│   ├── entities/        # LocalGeo (entidade compartilhada)
│   ├── error/           # Failure classes (Server, Cache, Network, Validation, NotFound)
│   ├── geo/             # GeoService, GpsCollector, OfflineGeoService
│   ├── network/         # HttpClient, NetworkInfo
│   ├── routing/         # AuthGate
│   ├── sync/            # SyncManager, SyncQueueDatasource
│   ├── utils/           # AppLogger, AppBlocObserver, DistanceCalculator
│   └── widgets/         # ErrorStateWidget, EmptyStateWidget, SyncStatusWidget, LocalSelector
├── features/
│   ├── auth/            # Login, sessão, AuthBloc
│   ├── atendimento/     # CRUD + status transitions, AtendimentoBloc
│   ├── base/            # Gestão de bases/garagens, BaseBloc
│   ├── cliente/         # CRUD de clientes, ClienteBloc
│   ├── dashboard/       # Métricas, DashboardCubit, HomePage
│   └── rastreamento/    # GPS tracking, RastreamentoBloc
```

## Setup e Execução

```bash
# Instalar dependências
flutter pub get

# Gerar código (Drift, Freezed, Injectable)
dart run build_runner build --delete-conflicting-outputs

# Rodar testes
flutter test

# Análise estática
dart analyze

# Executar (dev)
flutter run --dart-define=FLAVOR=dev

# Executar (staging/prod)
flutter run --dart-define=FLAVOR=staging
flutter run --dart-define=FLAVOR=prod

# Build release Android
flutter build appbundle --dart-define=FLAVOR=prod
```

## Flavors

| Flavor | API Base URL | App Name |
|--------|-------------|----------|
| `dev` | `http://10.0.2.2:3000` | GuinchoApp [DEV] |
| `staging` | `https://staging-api.guinchoapp.com.br` | GuinchoApp [STG] |
| `prod` | `https://api.guinchoapp.com.br` | GuinchoApp |

## Banco de Dados

7 tabelas Drift com schema v2:

- **Clientes** — cadastro de clientes
- **Usuarios** — operadores/administradores
- **Bases** — garagens/pontos de saída
- **Atendimentos** — ordens de serviço (com 4 locais, timestamps por etapa)
- **PontosRastreamento** — pontos GPS coletados
- **SyncQueue** — fila de sincronização offline
- **GeocodingCache** — cache de geocoding

### Índices (v2)

- `idx_atendimentos_status`, `idx_atendimentos_cliente`, `idx_atendimentos_criado`
- `idx_pontos_atendimento`, `idx_pontos_synced`
- `idx_sync_proxima_tentativa`

## Stack

| Camada | Tecnologia |
|--------|-----------|
| Estado | flutter_bloc ^8.1.6 |
| Banco | drift ^2.20.0 |
| DI | get_it ^8.0.2 + injectable ^2.4.4 |
| HTTP | dio ^5.7.0 |
| GPS | geolocator ^13.0.2 |
| Mapas | flutter_map ^7.0.2 |
| Testes | mocktail ^1.0.4, bloc_test ^9.1.7 |

## Progresso

| Sprint | Status | Testes |
|--------|--------|--------|
| 0 — Setup Inicial | ✅ | — |
| 1 — Autenticação | ✅ | — |
| 2 — Base + Cliente | ✅ | — |
| 3 — Geocoding + LocalSelector | ✅ | — |
| 4 — Atendimento | ✅ | 206 |
| 5 — Rastreamento GPS | ✅ | 205 |
| 6 — Sincronização | ✅ | 233 |
| 7 — Dashboard | ✅ | 279 |
| 8 — Polimento e QA | ✅ | 345 |

Consulte [PLANO_DESENVOLVIMENTO.md](PLANO_DESENVOLVIMENTO.md) para detalhes completos.
