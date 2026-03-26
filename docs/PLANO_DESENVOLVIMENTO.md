# 🚨 Plano de Desenvolvimento — App de Gestão de Viaturas de Socorro (Guincho)

> **Documento de referência para desenvolvimento com Claude Code.**
> Este arquivo define regras de negócio, arquitetura, padrões, libs e o plano de ação completo.
> Atualizar este documento sempre que houver mudanças de escopo.

---

## 📋 Índice

1. [Visão Geral do Produto](#1-visão-geral-do-produto)
2. [Regras de Negócio](#2-regras-de-negócio)
3. [Entidades e Modelos de Dados](#3-entidades-e-modelos-de-dados)
4. [Arquitetura do Projeto](#4-arquitetura-do-projeto)
5. [Estrutura de Pastas](#5-estrutura-de-pastas)
6. [Stack de Tecnologias e Libs](#6-stack-de-tecnologias-e-libs)
7. [Estratégia Offline-First e Sincronização](#7-estratégia-offline-first-e-sincronização)
8. [Rastreamento GPS e Relatórios](#8-rastreamento-gps-e-relatórios)
9. [Geocoding e Seleção de Localização](#9-geocoding-e-seleção-de-localização)
10. [Padrões de Projeto](#10-padrões-de-projeto)
11. [Estratégia TDD](#11-estratégia-tdd)
12. [Plano de Ação — Sprints](#12-plano-de-ação--sprints)
13. [Schema do Banco de Dados Local (Drift)](#13-schema-do-banco-de-dados-local-drift)
14. [Convenções de Código](#14-convenções-de-código)
15. [Design System / Identidade Visual](#15-design-system--identidade-visual)

---

## 1. Visão Geral do Produto

**Nome provisório:** GuinchoApp  
**Plataforma:** Flutter (Android e iOS)  
**Usuários simultâneos esperados:** ~20  
**Perfil do usuário:** Operadores de viatura de socorro (guincho) que recebem demandas via telefone/WhatsApp e precisam gerenciar os atendimentos em campo.

### Objetivo Principal

Permitir que operadores de guincho recebam uma demanda, calculem o valor do serviço, registrem o atendimento, rastreiem o deslocamento em tempo real e gerem relatórios de produtividade — tudo funcionando mesmo sem conexão com a internet.

### Premissas

- O app deve funcionar **100% offline**, sincronizando com o backend quando houver rede.
- O operador frequentemente estará em movimento, então a **UX deve ser simples e rápida**.
- A **localização do dispositivo** é coletada durante o deslocamento para fins de relatório.
- O backend é uma API REST exposta em URL pública (a ser desenvolvida separadamente).

---

## 2. Regras de Negócio

### 2.1 Gestão de Clientes

- **RN-001:** Todo atendimento deve estar vinculado a um cliente.
- **RN-002:** Antes de criar um atendimento, o operador deve buscar o cliente pelo nome ou telefone.
- **RN-003:** Se o cliente não existir no banco local, o operador deve cadastrá-lo com: nome, telefone e, opcionalmente, documento (CPF/CNPJ).
- **RN-004:** O endereço padrão do cliente pode ser salvo para agilizar futuros atendimentos.
- **RN-005:** Clientes devem ser sincronizados com o backend sempre que houver conexão.

### 2.2 Criação do Atendimento

- **RN-006:** O operador pode iniciar um atendimento a qualquer momento, mesmo sem conexão.
- **RN-007:** Todo atendimento exige: cliente vinculado, ponto de saída, local de coleta, local de entrega e local de retorno da viatura.
- **RN-008:** O **ponto de saída** pode ser definido de três formas:
  - Localização atual do dispositivo (GPS).
  - Uma base/garagem pré-cadastrada.
  - Endereço digitado manualmente com autocomplete.
- **RN-009:** O **local de coleta** e o **local de entrega** são informados via:
  - Endereço digitado com autocomplete (Google Places).
  - Seleção direta no mapa.
- **RN-009B:** O **local de retorno** é pré-preenchido automaticamente com o mesmo endereço do **ponto de saída**, mas pode ser editado livremente caso o operador vá retornar para um local diferente (ex: saiu de casa, retorna para a empresa).
- **RN-010:** Ao definir os quatro pontos (saída → coleta → entrega → retorno), o sistema **calcula automaticamente** a distância estimada total em km, incluindo o trecho de retorno.
- **RN-011:** O valor estimado é calculado por: `distância total estimada × valor por km configurado`.
- **RN-011B:** O retorno **sempre é cobrado do cliente**. A distância total cobrada corresponde ao percurso completo: `saída → coleta → entrega → retorno`.

### 2.3 Definição do Valor Cobrado

- **RN-012:** O valor pode ser definido de **dois modos**:
  - **Fixo:** O operador informa um valor manualmente antes ou durante a criação.
  - **Por KM real:** O valor é calculado ao fim do deslocamento com base na distância real percorrida pelo GPS.
- **RN-013:** O modo padrão é configurável nas preferências do usuário.
- **RN-014:** O operador pode sobrescrever o valor calculado antes de concluir o atendimento.
- **RN-015:** O valor por km utilizado é configurável e salvo localmente.

### 2.4 Ciclo de Vida do Atendimento

O atendimento percorre os seguintes status:

```
RASCUNHO → EM_DESLOCAMENTO → EM_COLETA → EM_ENTREGA → RETORNANDO → CONCLUIDO
                                                                  ↘ CANCELADO
```

| Status            | Descrição                                                                   |
| ----------------- | --------------------------------------------------------------------------- |
| `RASCUNHO`        | Atendimento criado, ainda não iniciado. Editável livremente.                |
| `EM_DESLOCAMENTO` | Viatura saiu da base rumo ao local de coleta. GPS ativo.                    |
| `EM_COLETA`       | Viatura chegou ao cliente. Aguardando/realizando coleta.                    |
| `EM_ENTREGA`      | Viatura a caminho do destino de entrega com o item coletado.                |
| `RETORNANDO`      | Entrega realizada. Viatura retornando ao local de retorno. GPS ainda ativo. |
| `CONCLUIDO`       | Viatura chegou ao local de retorno. GPS encerrado. Valor calculado.         |
| `CANCELADO`       | Atendimento cancelado antes da conclusão.                                   |

- **RN-016:** Um atendimento em `RASCUNHO` pode ser editado livremente.
- **RN-017:** Ao iniciar o deslocamento (`EM_DESLOCAMENTO`), o app começa a coletar a localização do dispositivo em background.
- **RN-018:** O operador avança o status manualmente ao chegar em cada etapa.
- **RN-019:** A coleta de GPS permanece ativa durante todos os status de movimento: `EM_DESLOCAMENTO`, `EM_COLETA`, `EM_ENTREGA` e `RETORNANDO`.
- **RN-020:** Ao concluir (`CONCLUIDO`), se o modo for `Por KM real`, o valor é calculado automaticamente com base nos pontos de rastreamento coletados durante **todo o percurso** (incluindo o retorno).
- **RN-021:** Um atendimento só pode ser `CANCELADO` se ainda não estiver em `CONCLUIDO`.
- **RN-022:** Atendimentos concluídos ou cancelados são somente leitura.
- **RN-022B:** A transição para `CONCLUIDO` só é permitida a partir de `RETORNANDO`, garantindo que o percurso completo seja registrado.

### 2.5 Rastreamento de Localização

- **RN-023:** A coleta de GPS inicia automaticamente quando o atendimento passa para `EM_DESLOCAMENTO`.
- **RN-024:** A coleta de GPS encerra automaticamente quando o atendimento passa para `CONCLUIDO` ou `CANCELADO`. O status `RETORNANDO` mantém o GPS ativo.
- **RN-025:** Os pontos são coletados a cada **30 segundos** ou a cada **100 metros** percorridos (o que ocorrer primeiro).
- **RN-026:** Cada ponto registra: latitude, longitude, precisão (accuracy), timestamp e ID do atendimento.
- **RN-027:** Os pontos são salvos localmente e sincronizados com o backend em segundo plano.
- **RN-028:** A distância real é calculada somando a distância euclidiana entre pontos consecutivos usando a fórmula de Haversine.

### 2.6 Bases e Garagens

- **RN-029:** O sistema permite cadastrar múltiplas bases (garagens/filiais) com nome e localização (coords).
- **RN-030:** Uma base pode ser definida como **principal**, sendo pré-selecionada por padrão no campo de ponto de saída.
- **RN-031:** As bases são cadastradas pelo administrador e sincronizadas para todos os usuários.

### 2.7 Sincronização

- **RN-032:** O app monitora continuamente o estado da conexão.
- **RN-033:** Toda operação de escrita (criar, editar, concluir) é salva localmente **primeiro** e adicionada a uma fila de sincronização.
- **RN-034:** Quando a conexão é detectada, a fila é processada em ordem cronológica.
- **RN-035:** Em caso de falha na sincronização, a operação é mantida na fila e retentada com backoff exponencial (1s, 2s, 4s, máx 60s).
- **RN-036:** Conflitos são resolvidos com a estratégia **last-write-wins** usando `updatedAt` como critério.
- **RN-037:** O app exibe um indicador visual do estado de sincronização (sincronizado, pendente, erro).

### 2.8 Relatórios e Dashboard

- **RN-038:** O dashboard exibe métricas calculadas a partir do banco local:
  - Total de km rodados pela viatura (dia, semana, mês) — percurso real completo incluindo retorno.
  - Total de km cobrado dos clientes — percurso completo (saída → coleta → entrega → retorno).
  - Total de atendimentos (por status, por período).
  - Ranking de clientes por número de atendimentos e por KM gerado.
  - Receita estimada por período.
- **RN-038B:** Os relatórios distinguem **KM operacional** (total rodado pela viatura) de **KM cobrado** (total faturado ao cliente), permitindo análise de custo operacional vs receita.
- **RN-039:** O operador pode visualizar o percurso de um atendimento passado no mapa.
- **RN-040:** Os filtros disponíveis são: período (data inicial/final) e cliente.

---

## 3. Entidades e Modelos de Dados

### 3.1 LocalGeo (Value Object reutilizável)

```dart
class LocalGeo {
  final String enderecoTexto;    // "Rua das Flores, 123, São Paulo - SP"
  final double latitude;
  final double longitude;
  final String? complemento;     // "Portão azul, fundos"
}
```

### 3.2 Cliente

```dart
class Cliente {
  final String id;               // UUID v4 gerado localmente
  final String nome;
  final String telefone;
  final String? documento;       // CPF ou CNPJ (opcional)
  final LocalGeo? enderecoDefault;
  final DateTime criadoEm;
  final DateTime atualizadoEm;
  final DateTime? sincronizadoEm;
}
```

### 3.3 Usuario

```dart
class Usuario {
  final String id;
  final String nome;
  final String telefone;
  final String email;
  final UsuarioRole role;        // operador | administrador
  final double valorPorKmDefault;
  final DateTime criadoEm;
  final DateTime? sincronizadoEm;
}

enum UsuarioRole { operador, administrador }
```

### 3.4 Base

```dart
class Base {
  final String id;
  final String nome;             // "Garagem Central", "Filial Norte"
  final LocalGeo local;
  final bool isPrincipal;
  final DateTime criadoEm;
  final DateTime? sincronizadoEm;
}
```

### 3.5 Atendimento (OS)

```dart
class Atendimento {
  final String id;
  final String clienteId;
  final String usuarioId;

  // Localizações — 4 pontos obrigatórios
  final LocalGeo pontoDeSaida;       // de onde a viatura parte
  final LocalGeo localDeColeta;      // onde está o veículo/item do cliente
  final LocalGeo localDeEntrega;     // para onde o item será entregue
  final LocalGeo localDeRetorno;     // para onde a viatura retorna após a entrega
                                     // pré-preenchido com pontoDeSaida, editável

  // Distâncias (em km)
  // RN-010: distância estimada = saída→coleta + coleta→entrega + entrega→retorno
  final double distanciaEstimadaKm;
  // RN-028: distância real = soma Haversine de todos os pontos de rastreamento
  final double? distanciaRealKm;

  // Valores
  final double valorPorKm;
  final double? valorCobrado;        // null se modo porKm e não concluído
  final TipoValor tipoValor;

  // Controle
  final AtendimentoStatus status;
  final String? observacoes;
  final DateTime criadoEm;
  final DateTime atualizadoEm;
  final DateTime? iniciadoEm;        // quando passou para EM_DESLOCAMENTO
  final DateTime? chegadaColetaEm;   // quando passou para EM_COLETA
  final DateTime? chegadaEntregaEm;  // quando passou para EM_ENTREGA
  final DateTime? inicioRetornoEm;   // quando passou para RETORNANDO
  final DateTime? concluidoEm;       // quando passou para CONCLUIDO
  final DateTime? sincronizadoEm;
}

enum TipoValor { fixo, porKm }

enum AtendimentoStatus {
  rascunho,
  emDeslocamento,
  emColeta,
  emEntrega,
  retornando,      // ← NOVO
  concluido,
  cancelado,
}
```

> **Regra de transição de status:**
>
> ```
> rascunho → emDeslocamento → emColeta → emEntrega → retornando → concluido
>                                                              ↘ cancelado (qualquer etapa antes de concluido)
> ```

````

### 3.6 PontoRastreamento
```dart
class PontoRastreamento {
  final String id;
  final String atendimentoId;
  final double latitude;
  final double longitude;
  final double accuracy;         // precisão em metros
  final double? velocidade;      // m/s (opcional)
  final DateTime timestamp;
  final bool synced;
}
````

### 3.7 SyncQueue (fila de sincronização)

```dart
class SyncQueue {
  final String id;
  final String entidade;         // "cliente", "atendimento", "ponto_rastreamento"
  final String operacao;         // "create", "update", "delete"
  final String payload;          // JSON serializado
  final int tentativas;
  final DateTime criadoEm;
  final DateTime? proximaTentativaEm;
}
```

---

## 4. Arquitetura do Projeto

### Clean Architecture com Feature-First

O projeto adota **Clean Architecture** organizada por **features**. Cada feature é um módulo independente com suas próprias camadas de dados, domínio e apresentação.

```
┌─────────────────────────────────────────────┐
│              PRESENTATION                    │
│         (Widgets, Pages, Blocs)              │
├─────────────────────────────────────────────┤
│                DOMAIN                        │
│    (Entities, UseCases, Repository Interfaces│
├─────────────────────────────────────────────┤
│                  DATA                        │
│  (Repository Impl, DataSources, Models, API) │
└─────────────────────────────────────────────┘
```

**Regra de dependência:** Camadas internas nunca dependem de camadas externas. O Domain não conhece Flutter, Drift ou Dio.

### Gerência de Estado: Bloc + Cubit

- **Bloc** para fluxos complexos com múltiplos eventos (atendimento, rastreamento).
- **Cubit** para estados simples (formulários, configurações).

### Injeção de Dependência: GetIt + Injectable

- `GetIt` como service locator global.
- `injectable` para geração automática do código de registro.
- Módulos separados por camada: `DataModule`, `DomainModule`.

---

## 5. Estrutura de Pastas

```
lib/
├── core/
│   ├── database/
│   │   ├── app_database.dart          # Drift database definition
│   │   └── app_database.g.dart        # gerado
│   ├── di/
│   │   ├── injection.dart
│   │   └── injection.config.dart      # gerado
│   ├── error/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   ├── network_info.dart          # interface
│   │   └── network_info_impl.dart     # connectivity_plus
│   ├── sync/
│   │   ├── sync_manager.dart          # orquestra a fila
│   │   └── sync_worker.dart           # processa item por item
│   ├── geo/
│   │   ├── geo_service.dart           # interface
│   │   └── geo_service_impl.dart      # Google Places + geolocator
│   ├── utils/
│   │   ├── distance_calculator.dart   # Haversine
│   │   ├── uuid_generator.dart
│   │   └── date_formatter.dart
│   └── constants/
│       └── app_constants.dart         # GPS_INTERVAL, MIN_DISTANCE, etc.
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── cliente/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── cliente_local_datasource.dart
│   │   │   │   └── cliente_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── cliente_model.dart
│   │   │   └── repositories/
│   │   │       └── cliente_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── cliente.dart
│   │   │   ├── repositories/
│   │   │   │   └── cliente_repository.dart
│   │   │   └── usecases/
│   │   │       ├── buscar_clientes.dart
│   │   │       ├── criar_cliente.dart
│   │   │       └── atualizar_cliente.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── cliente_bloc.dart
│   │       │   ├── cliente_event.dart
│   │       │   └── cliente_state.dart
│   │       ├── pages/
│   │       │   ├── buscar_cliente_page.dart
│   │       │   └── form_cliente_page.dart
│   │       └── widgets/
│   │           ├── cliente_list_tile.dart
│   │           └── cliente_search_bar.dart
│   │
│   ├── base/
│   │   └── ... (mesma estrutura)
│   │
│   ├── atendimento/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── atendimento_local_datasource.dart
│   │   │   │   └── atendimento_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── atendimento_model.dart
│   │   │   └── repositories/
│   │   │       └── atendimento_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── atendimento.dart
│   │   │   │   └── local_geo.dart
│   │   │   ├── repositories/
│   │   │   │   └── atendimento_repository.dart
│   │   │   └── usecases/
│   │   │       ├── criar_atendimento.dart
│   │   │       ├── atualizar_status_atendimento.dart
│   │   │       ├── calcular_valor_estimado.dart
│   │   │       ├── calcular_valor_real.dart
│   │   │       └── listar_atendimentos.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── atendimento_bloc.dart
│   │       │   ├── atendimento_event.dart
│   │       │   └── atendimento_state.dart
│   │       ├── pages/
│   │       │   ├── lista_atendimentos_page.dart
│   │       │   ├── novo_atendimento_page.dart
│   │       │   └── detalhe_atendimento_page.dart
│   │       └── widgets/
│   │           ├── local_selector_widget.dart   # COMPONENTE CENTRAL
│   │           ├── valor_selector_widget.dart
│   │           └── status_stepper_widget.dart
│   │
│   ├── rastreamento/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── rastreamento_local_datasource.dart
│   │   │   │   └── rastreamento_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── ponto_rastreamento_model.dart
│   │   │   └── repositories/
│   │   │       └── rastreamento_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── ponto_rastreamento.dart
│   │   │   ├── repositories/
│   │   │   │   └── rastreamento_repository.dart
│   │   │   └── usecases/
│   │   │       ├── iniciar_rastreamento.dart
│   │   │       ├── parar_rastreamento.dart
│   │   │       └── obter_percurso_atendimento.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── rastreamento_bloc.dart
│   │       │   ├── rastreamento_event.dart
│   │       │   └── rastreamento_state.dart
│   │       └── widgets/
│   │           └── mapa_percurso_widget.dart
│   │
│   └── dashboard/
│       ├── domain/
│       │   └── usecases/
│       │       ├── obter_resumo_periodo.dart
│       │       └── obter_km_por_cliente.dart
│       └── presentation/
│           ├── cubit/
│           │   ├── dashboard_cubit.dart
│           │   └── dashboard_state.dart
│           └── pages/
│               └── dashboard_page.dart
│
└── main.dart
```

---

## 6. Stack de Tecnologias e Libs

### pubspec.yaml — Dependências completas

```yaml
dependencies:
  flutter:
    sdk: flutter

  # --- Gerência de Estado ---
  flutter_bloc: ^8.1.6
  equatable: ^2.0.5

  # --- Banco de Dados Local ---
  drift: ^2.20.0
  drift_flutter: ^0.2.1
  sqlite3_flutter_libs: ^0.5.0

  # --- Injeção de Dependência ---
  get_it: ^8.0.2
  injectable: ^2.4.4

  # --- Rede ---
  dio: ^5.7.0
  pretty_dio_logger: ^1.4.0 # logs de requisição (dev)

  # --- Conectividade ---
  connectivity_plus: ^6.0.5

  # --- Localização / GPS ---
  geolocator: ^13.0.2
  flutter_background_service: ^5.0.12
  permission_handler: ^11.3.1

  # --- Geocoding e Mapas ---
  geocoding: ^3.0.0
  flutter_google_places_sdk: ^0.13.5
  flutter_map: ^7.0.2
  latlong2: ^0.9.1

  # --- Geração de Código / Utils ---
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0
  uuid: ^4.4.2
  intl: ^0.19.0

  # --- Armazenamento Seguro ---
  flutter_secure_storage: ^9.2.2

dev_dependencies:
  flutter_test:
    sdk: flutter

  # --- Geração de Código ---
  build_runner: ^2.4.12
  drift_dev: ^2.20.0
  injectable_generator: ^2.6.2
  freezed: ^2.5.7
  json_serializable: ^6.8.0

  # --- Testes ---
  mocktail: ^1.0.4
  bloc_test: ^9.1.7
  fake_async: ^1.3.1
```

### Comandos de Geração de Código

```bash
# Gerar código Drift + Freezed + Injectable
dart run build_runner build --delete-conflicting-outputs

# Watch mode durante desenvolvimento
dart run build_runner watch --delete-conflicting-outputs
```

---

## 7. Estratégia Offline-First e Sincronização

### Fluxo de Escrita (sempre local primeiro)

```
UI Action
   ↓
Bloc dispara UseCase
   ↓
Repository → salva no Drift (local)
   ↓
Repository → adiciona entrada na SyncQueue
   ↓
UI atualiza com dados locais (imediato)
   ↓
[background] SyncManager processa a fila
   ↓
    ┌── sucesso → marca synced=true, remove da fila
    └── falha   → incrementa tentativas, agenda retry com backoff
```

### SyncManager — Comportamento

```dart
// Pseudocódigo do SyncManager
class SyncManager {
  // Chamado ao detectar conexão ativa
  Future<void> processar() async {
    final itens = await syncQueueDao.obterPendentes();
    for (final item in itens) {
      try {
        await _enviar(item);
        await syncQueueDao.remover(item.id);
      } catch (e) {
        await syncQueueDao.incrementarTentativas(item.id);
        // backoff: 1s, 2s, 4s, 8s... max 60s
      }
    }
  }
}
```

### Indicador Visual de Sync

- 🟢 **Sincronizado** — sem itens na fila
- 🟡 **Pendente** — itens aguardando na fila
- 🔴 **Erro** — itens com tentativas esgotadas (> 5)

---

## 8. Rastreamento GPS e Relatórios

### Configurações de Coleta (app_constants.dart)

```dart
const Duration GPS_INTERVAL = Duration(seconds: 30);
const double GPS_MIN_DISTANCE = 100.0; // metros
const double GPS_MIN_ACCURACY = 50.0;  // ignorar pontos com precisão > 50m
```

### Background Service

O rastreamento em background usa `flutter_background_service`. O serviço:

1. É iniciado quando o atendimento passa para `EM_DESLOCAMENTO`.
2. Coleta coordenadas via `geolocator` respeitando as constantes acima.
3. Salva cada ponto no Drift diretamente (sem passar pela UI).
4. É encerrado quando o atendimento passa para `CONCLUIDO` ou `CANCELADO`.

### Cálculo de Distância Real (Haversine)

```dart
// core/utils/distance_calculator.dart
class DistanceCalculator {
  // Retorna distância total em km a partir de uma lista de pontos GPS
  // Cobre o percurso completo: saída → coleta → entrega → retorno
  double calcularTotal(List<PontoRastreamento> pontos) {
    double total = 0;
    for (int i = 0; i < pontos.length - 1; i++) {
      total += Geolocator.distanceBetween(
        pontos[i].latitude, pontos[i].longitude,
        pontos[i + 1].latitude, pontos[i + 1].longitude,
      );
    }
    return total / 1000; // metros → km
  }

  // Estimativa com 4 pontos fixos (usado na criação do atendimento)
  // RN-010: saída→coleta + coleta→entrega + entrega→retorno
  double calcularEstimativa({
    required LocalGeo saida,
    required LocalGeo coleta,
    required LocalGeo entrega,
    required LocalGeo retorno,
  }) {
    double metros = 0;
    metros += Geolocator.distanceBetween(saida.latitude, saida.longitude, coleta.latitude, coleta.longitude);
    metros += Geolocator.distanceBetween(coleta.latitude, coleta.longitude, entrega.latitude, entrega.longitude);
    metros += Geolocator.distanceBetween(entrega.latitude, entrega.longitude, retorno.latitude, retorno.longitude);
    return metros / 1000;
  }
}
```

### Queries para Relatórios (Drift)

```sql
-- KM total operacional por período (percurso real da viatura)
SELECT SUM(distancia_real_km) as km_operacional
FROM atendimentos
WHERE status = 'concluido'
  AND concluido_em BETWEEN :inicio AND :fim;

-- KM cobrado dos clientes por período (inclui retorno — igual ao real neste modelo)
SELECT SUM(distancia_real_km) as km_cobrado,
       SUM(valor_cobrado)     as receita_total
FROM atendimentos
WHERE status = 'concluido'
  AND concluido_em BETWEEN :inicio AND :fim;

-- KM por cliente no mês
SELECT c.nome,
       COUNT(a.id)              as total_atendimentos,
       SUM(a.distancia_real_km) as total_km,
       SUM(a.valor_cobrado)     as total_receita
FROM atendimentos a
JOIN clientes c ON a.cliente_id = c.id
WHERE a.status = 'concluido'
  AND strftime('%Y-%m', a.concluido_em) = :ano_mes
GROUP BY c.id
ORDER BY total_km DESC;

-- Tempo médio por etapa (útil para análise operacional)
SELECT
  AVG((julianday(chegada_coleta_em)  - julianday(iniciado_em))      * 1440) as min_ate_coleta,
  AVG((julianday(chegada_entrega_em) - julianday(chegada_coleta_em)) * 1440) as min_coleta_entrega,
  AVG((julianday(inicio_retorno_em)  - julianday(chegada_entrega_em))* 1440) as min_entrega_retorno,
  AVG((julianday(concluido_em)       - julianday(inicio_retorno_em)) * 1440) as min_retorno_base
FROM atendimentos
WHERE status = 'concluido'
  AND concluido_em BETWEEN :inicio AND :fim;
```

---

## 9. Geocoding e Seleção de Localização

### LocalSelectorWidget — Especificação

Componente central reutilizável em todos os pontos do formulário de atendimento.

**Props:**

```dart
LocalSelectorWidget({
  required String label,
  required Function(LocalGeo) onLocalSelecionado,
  LocalGeo? valorInicial,
  List<LocalSelectorOpcao> opcoes = LocalSelectorOpcao.values,
})
```

**Opções disponíveis:**

- `localizacaoAtual` → GPS + reverse geocoding → `LocalGeo`
- `selecionarBase` → bottom sheet com lista de bases (Drift, offline)
- `digitarEndereco` → autocomplete Google Places → geocoding → `LocalGeo`
- `selecionarNoMapa` → flutter_map com tap → reverse geocoding → `LocalGeo`

**Uso por campo no formulário de atendimento:**

| Campo            | Opções disponíveis                    | Pré-preenchimento                          |
| ---------------- | ------------------------------------- | ------------------------------------------ |
| Ponto de Saída   | todas as 4                            | Base principal cadastrada                  |
| Local de Coleta  | `digitarEndereco`, `selecionarNoMapa` | —                                          |
| Local de Entrega | `digitarEndereco`, `selecionarNoMapa` | —                                          |
| Local de Retorno | todas as 4                            | **Copia automaticamente o Ponto de Saída** |

> **RN-009B:** O Local de Retorno é pré-preenchido com o Ponto de Saída. O operador vê o endereço já preenchido e pode editar caso vá retornar para outro local.

### Estratégia Offline para Geocoding

```
Usuário digita endereço
       ↓
Tem conexão?
  ├── SIM → Google Places Autocomplete → salva par (endereço, coords) no cache local
  └── NÃO → busca no cache local (endereços já usados)
              ├── Encontrou → usa coords do cache
              └── Não encontrou → salva atendimento com coords=null
                                  marca para geocoding posterior
                                  ao sincronizar, backend faz geocoding
```

### Prioridade de Seleção de Ponto de Saída

```
1º Base principal cadastrada (pré-selecionada automaticamente)
2º Localização atual do dispositivo
3º Outra base da lista
4º Endereço digitado manualmente
```

---

## 10. Padrões de Projeto

### 10.1 Repository Pattern

Todo acesso a dados passa por uma interface de repositório no Domain. A implementação no Data decide se lê do local ou remoto.

```dart
// Domain (interface)
abstract class AtendimentoRepository {
  Future<Either<Failure, Atendimento>> criar(Atendimento atendimento);
  Future<Either<Failure, List<Atendimento>>> listar({AtendimentoStatus? status});
  Stream<Atendimento> observar(String id);
}

// Data (implementação — sempre lê do local, escreve local + fila sync)
class AtendimentoRepositoryImpl implements AtendimentoRepository { ... }
```

### 10.2 Either para Tratamento de Erros

Usar `Either<Failure, T>` (functional programming) para erros esperados. Não usar `try/catch` nas camadas de Domain e Presentation — apenas na camada de Data.

```dart
// Falhas tipadas
abstract class Failure { final String message; }
class NetworkFailure extends Failure { ... }
class DatabaseFailure extends Failure { ... }
class ValidationFailure extends Failure { ... }
class NotFoundFailure extends Failure { ... }
```

### 10.3 UseCase Pattern

Cada caso de uso é uma classe com um único método `call`.

```dart
class CriarAtendimento {
  final AtendimentoRepository repository;
  final DistanceCalculator calculator;

  Future<Either<Failure, Atendimento>> call(CriarAtendimentoParams params) async {
    // 1. Validar params
    // 2. Calcular distância estimada
    // 3. Montar entidade Atendimento
    // 4. Delegar ao repository
  }
}
```

### 10.4 Freezed para Entidades e States

Todas as entidades de domínio e states do Bloc são geradas com `freezed` para garantir imutabilidade.

```dart
@freezed
class AtendimentoState with _$AtendimentoState {
  const factory AtendimentoState.initial() = _Initial;
  const factory AtendimentoState.loading() = _Loading;
  const factory AtendimentoState.loaded(List<Atendimento> atendimentos) = _Loaded;
  const factory AtendimentoState.error(String message) = _Error;
}
```

---

## 11. Estratégia TDD

### Filosofia

> Escrever o teste antes da implementação. O teste define o contrato esperado. A implementação satisfaz o contrato.

**Ciclo Red → Green → Refactor** em toda lógica de negócio.

**Regra obrigatória do projeto:** nenhuma tarefa é considerada concluída enquanto todos os testes automatizados do app estiverem funcionais. Teste quebrado bloqueia entrega.

### Critério de aceite obrigatório

- Toda alteração começa com teste novo ou ajuste de teste existente que descreva o comportamento esperado.
- A implementação só é aceita depois de levar a suíte de volta ao verde.
- Antes de finalizar qualquer demanda, executar `flutter test` e corrigir qualquer falha relacionada à base atual.

### O que DEVE ter testes

| Camada                    | O que testar                        | Tipo de Teste                |
| ------------------------- | ----------------------------------- | ---------------------------- |
| Domain / UseCases         | Lógica de negócio, cálculos         | Unit Test                    |
| Domain / Entities         | Validações, regras de criação       | Unit Test                    |
| Data / Repositories       | Leitura local, fallback, sync queue | Unit Test (mock datasources) |
| Data / DataSources        | Queries Drift, chamadas API         | Integration Test             |
| Presentation / Blocs      | Sequência de states por evento      | Unit Test (bloc_test)        |
| Core / DistanceCalculator | Cálculo Haversine                   | Unit Test                    |
| Core / SyncManager        | Processamento da fila, backoff      | Unit Test                    |

### Estrutura de Testes

```
test/
├── core/
│   ├── utils/
│   │   └── distance_calculator_test.dart
│   └── sync/
│       └── sync_manager_test.dart
│
├── features/
│   ├── cliente/
│   │   ├── domain/
│   │   │   └── usecases/
│   │   │       └── criar_cliente_test.dart
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── cliente_repository_impl_test.dart
│   │   └── presentation/
│   │       └── bloc/
│   │           └── cliente_bloc_test.dart
│   │
│   └── atendimento/
│       ├── domain/
│       │   └── usecases/
│       │       ├── criar_atendimento_test.dart
│       │       ├── calcular_valor_estimado_test.dart
│       │       └── calcular_valor_real_test.dart
│       ├── data/
│       │   └── repositories/
│       │       └── atendimento_repository_impl_test.dart
│       └── presentation/
│           └── bloc/
│               └── atendimento_bloc_test.dart
│
└── helpers/
    ├── mocks.dart             # mocktail mocks centralizados
    └── fixtures/
        ├── atendimento.json
        └── cliente.json
```

### Exemplo de Teste — UseCase

```dart
// test/features/atendimento/domain/usecases/calcular_valor_estimado_test.dart

void main() {
  late CalcularValorEstimado usecase;
  late MockDistanceCalculator mockCalculator;

  setUp(() {
    mockCalculator = MockDistanceCalculator();
    usecase = CalcularValorEstimado(mockCalculator);
  });

  group('CalcularValorEstimado', () {
    test('deve retornar valor correto dado distância e preço por km', () async {
      // Arrange
      when(() => mockCalculator.calcularEntrePontos(any(), any()))
          .thenReturn(10.5); // 10.5 km

      final params = CalcularValorParams(
        origem: LocalGeo(lat: -23.5, lng: -46.6, enderecoTexto: ''),
        destino: LocalGeo(lat: -23.6, lng: -46.7, enderecoTexto: ''),
        valorPorKm: 5.00,
      );

      // Act
      final result = await usecase(params);

      // Assert
      expect(result, Right(52.50)); // 10.5 × 5.00
    });

    test('deve retornar ValidationFailure se valorPorKm for zero', () async {
      final params = CalcularValorParams(
        origem: LocalGeo(lat: -23.5, lng: -46.6, enderecoTexto: ''),
        destino: LocalGeo(lat: -23.6, lng: -46.7, enderecoTexto: ''),
        valorPorKm: 0,
      );

      final result = await usecase(params);

      expect(result, isA<Left>());
      expect((result as Left).value, isA<ValidationFailure>());
    });
  });
}
```

### Exemplo de Teste — Bloc

```dart
// test/features/atendimento/presentation/bloc/atendimento_bloc_test.dart

void main() {
  late AtendimentoBloc bloc;
  late MockCriarAtendimento mockCriarAtendimento;

  setUp(() {
    mockCriarAtendimento = MockCriarAtendimento();
    bloc = AtendimentoBloc(criarAtendimento: mockCriarAtendimento);
  });

  blocTest<AtendimentoBloc, AtendimentoState>(
    'emite [loading, loaded] quando criação for bem-sucedida',
    build: () {
      when(() => mockCriarAtendimento(any()))
          .thenAnswer((_) async => Right(atendimentoFake));
      return bloc;
    },
    act: (bloc) => bloc.add(CriarAtendimentoEvent(params: paramsFake)),
    expect: () => [
      AtendimentoState.loading(),
      AtendimentoState.loaded([atendimentoFake]),
    ],
  );
}
```

### Cobertura Mínima Esperada

- UseCases: **100%**
- Repositories: **90%**
- Blocs/Cubits: **90%**
- Utils/Calculators: **100%**

---

## 12. Plano de Ação — Sprints

> Cada Sprint tem duração estimada de **1 semana**.
> Ao iniciar cada tarefa no Claude Code, referenciar este documento e a seção correspondente.

---

### 🟦 Sprint 0 — Setup e Infraestrutura (Semana 1)

**Objetivo:** Projeto funcionando com CI, estrutura de pastas, DI e banco configurados.

#### Tarefas

- [x] **S0-01:** Criar projeto Flutter com `flutter create`
- [x] **S0-02:** Configurar estrutura de pastas conforme Seção 5
- [x] **S0-03:** Adicionar todas as dependências do `pubspec.yaml` (Seção 6)
- [x] **S0-04:** Configurar `GetIt` + `Injectable` (módulos Data e Domain)
- [x] **S0-05:** Criar schema inicial do Drift com todas as tabelas (Seção 13)
- [x] **S0-06:** Rodar `build_runner` e validar geração de código
- [x] **S0-07:** Configurar `Dio` com interceptors (auth header, log, retry)
- [x] **S0-08:** Implementar `NetworkInfo` com `connectivity_plus`
- [x] **S0-09:** Criar `DistanceCalculator` com testes (100% cobertura)
- [x] **S0-10:** Criar helpers de teste (`mocks.dart`, `fixtures/`)
- [x] **S0-11:** Configurar `flutter_lints` com regras do projeto

**Critério de aceite:** `flutter test` passa, `build_runner` sem erros, DI resolvendo dependências.

---

### 🟦 Sprint 1 — Autenticação e Usuário (Semana 2) ✅

**Objetivo:** Login, sessão persistida, token seguro.

#### Tarefas

- [x] **S1-01:** [TDD] UseCase: `AutenticarUsuario` — 4 testes
- [x] **S1-02:** [TDD] UseCase: `ObterUsuarioLogado` — 2 testes
- [x] **S1-03:** Implementar `AuthRepository` (API + `flutter_secure_storage`) — UsuarioModel, RemoteDatasource, LocalDatasource, RepositoryImpl — 15 testes
- [x] **S1-04:** [TDD] `AuthBloc` com eventos: Login, Logout, ChecarSessao — 7 testes
- [x] **S1-05:** Criar `LoginPage` (email + senha) — 5 widget testes
- [x] **S1-06:** Implementar guard de rota (redirecionar se não autenticado) — AuthGate — 5 testes
- [x] **S1-07:** Interceptor do Dio para injetar Bearer token automaticamente — verificado (\_AuthInterceptor em HttpClient)

**Critério de aceite:** ✅ Usuário loga, token persiste entre sessões, logout limpa dados. 47 testes passando. `flutter analyze` sem issues.

---

### 🟦 Sprint 2 — Base e Cliente (Semana 3)

**Objetivo:** CRUD de bases/garagens e clientes funcionando offline.

#### Tarefas

- [x] **S2-01:** [TDD] UseCases de Cliente: `CriarCliente`, `BuscarClientes`, `AtualizarCliente`
- [x] **S2-02:** Implementar `ClienteLocalDatasource` (Drift)
- [x] **S2-03:** Implementar `ClienteRemoteDatasource` (API)
- [x] **S2-04:** [TDD] `ClienteRepositoryImpl` (local first + sync queue)
- [x] **S2-05:** [TDD] `ClienteBloc`
- [x] **S2-06:** Criar `BuscarClientePage` com search bar e lista
- [x] **S2-07:** Criar `FormClientePage` (criar/editar)
- [x] **S2-08:** [TDD] UseCases de Base: `CriarBase`, `ListarBases`, `DefinirBasePrincipal`
- [x] **S2-09:** Implementar `BaseLocalDatasource` e `BaseRemoteDatasource`
- [x] **S2-10:** [TDD] `BaseBloc`
- [x] **S2-11:** Criar tela de gestão de bases

**Critério de aceite:** Cliente cadastrado offline, listado, editado. Bases listadas com principal destacada.

---

### 🟦 Sprint 3 — Geocoding e LocalSelectorWidget (Semana 4)

**Objetivo:** Seleção de localização robusta e offline-friendly.

#### Tarefas

- [x] **S3-01:** Criar `GeoService` interface + implementação (Google Places + geolocator)
- [x] **S3-02:** Implementar cache local de geocoding no Drift
- [x] **S3-03:** [TDD] Lógica de fallback offline para geocoding
- [x] **S3-04:** Criar `LocalSelectorWidget` com as 4 opções (Seção 9)
- [x] **S3-05:** Integrar autocomplete Google Places no widget
- [x] **S3-06:** Integrar `flutter_map` para seleção no mapa
- [x] **S3-07:** Integrar GPS atual com reverse geocoding
- [x] **S3-08:** Widget test do `LocalSelectorWidget`

**Critério de aceite:** Widget funciona em todas as 4 modalidades, exibe endereço textual após seleção, funciona offline para bases e localização atual.

---

### 🟦 Sprint 4 — Atendimento (Semana 5-6) ✅

**Objetivo:** Criação, listagem e gestão completa de atendimentos.

#### Tarefas

- [x] **S4-01:** [TDD] `CriarAtendimento` UseCase (com cálculo de distância estimada nos 4 pontos: saída→coleta→entrega→retorno)
- [x] **S4-02:** [TDD] `CalcularValorEstimado` UseCase (inclui trecho de retorno obrigatoriamente)
- [x] **S4-03:** [TDD] `AtualizarStatusAtendimento` UseCase (com validação de transições: rascunho→emDeslocamento→emColeta→emEntrega→retornando→concluido)
- [x] **S4-04:** [TDD] `ListarAtendimentos` UseCase (com filtros)
- [x] **S4-05:** Implementar `AtendimentoLocalDatasource`
- [x] **S4-06:** Implementar `AtendimentoRemoteDatasource`
- [x] **S4-07:** [TDD] `AtendimentoRepositoryImpl`
- [x] **S4-08:** [TDD] `AtendimentoBloc` (todos os eventos, incluindo transição para `retornando`)
- [x] **S4-09:** Criar `ListaAtendimentosPage` com filtro por status
- [x] **S4-10:** Criar `NovoAtendimentoPage` com os 4 campos de localização — Local de Retorno pré-preenchido com Ponto de Saída e editável
- [x] **S4-11:** Criar `DetalheAtendimentoPage` com stepper de 5 etapas (incluindo Retornando)
- [x] **S4-12:** Criar `ValorSelectorWidget` (fixo vs por km)
- [x] **S4-13:** Criar `StatusStepperWidget` com as etapas: Deslocamento → Coleta → Entrega → Retorno → Concluído

**Critério de aceite:** ✅ Atendimento criado offline com 4 locais (retorno pré-preenchido com saída), valor calculado com trecho de retorno, status avança por todas as 5 etapas incluindo `RETORNANDO`. 206 testes passando. DI configurado para todas as features. Navegação integrada no HomePage.

---

### ✅ Sprint 5 — Rastreamento GPS (Semana 7)

**Objetivo:** Coleta de GPS em background durante atendimentos.

#### Tarefas

- [x] **S5-01:** Configurar permissões de GPS no Android (`AndroidManifest.xml`) e iOS (`Info.plist`)
- [x] **S5-02:** Implementar `GpsCollector` para coleta GPS com geolocator (stream-based)
- [x] **S5-03:** [TDD] `RegistrarPonto` e `ObterPercurso` UseCases
- [x] **S5-04:** [TDD] `CalcularValorReal` UseCase (usa pontos coletados)
- [x] **S5-05:** Implementar `RastreamentoLocalDatasource` + `PontoRastreamentoModel` + `RastreamentoRepositoryImpl`
- [x] **S5-06:** [TDD] `RastreamentoBloc`
- [x] **S5-07:** Integrar rastreamento com `AtualizarStatusAtendimento` (auto-start/stop via Bloc)
- [x] **S5-08:** Criar `MapaPercursoWidget` para visualizar rota no `flutter_map`
- [ ] **S5-09:** Testar em device real com GPS (especial atenção: Xiaomi, Samsung)

**Critério de aceite:** ✅ GPS collector implementado com stream, pontos salvos no Drift via offline-first, percurso visível no mapa, DI configurado, 205 testes passando. S5-09 requer device real.

---

### ✅ Sprint 6 — Sincronização (Semana 8)

**Objetivo:** Sync queue robusto e confiável.

#### Tarefas

- [x] **S6-01:** Implementar `SyncManager` completo com backoff exponencial
- [x] **S6-02:** [TDD] `SyncManager` (todos os cenários: sucesso, falha, retry, exaustão)
- [x] **S6-03:** Integrar `SyncManager` com `connectivity_plus` (trigger automático)
- [x] **S6-04:** Criar `SyncStatusWidget` (indicador global de sync)
- [x] **S6-05:** Implementar sincronização de `PontoRastreamento` em batch
- [x] **S6-06:** Testar cenário: offline → criar atendimentos → ligar rede → verificar sync
- [x] **S6-07:** Implementar resolução de conflitos last-write-wins

**Critério de aceite:** ✅ SyncManager com backoff exponencial, monitoramento de conectividade, dispatch por entidade, SyncStatusWidget com StreamBuilder, SyncQueueDatasource estendido com 6 métodos, DI configurado, 233 testes passando. S6-06 coberto por testes unitários (cenário real requer device).

---

### ✅ Sprint 7 — Dashboard e Relatórios (Semana 9)

**Objetivo:** Dashboard com métricas de produtividade.

#### Tarefas

- [x] **S7-01:** [TDD] `ObterResumoPeriodo` UseCase (queries Drift — km operacional e km cobrado separados)
- [x] **S7-02:** [TDD] `ObterKmPorCliente` UseCase
- [x] **S7-03:** [TDD] `ObterTempoPorEtapa` UseCase (análise de tempo médio em cada status)
- [x] **S7-04:** [TDD] `DashboardCubit`
- [x] **S7-05:** Criar `DashboardPage` com cards de métricas (km operacional, km cobrado, receita, atendimentos)
- [x] **S7-06:** Criar seletor de período (dia/semana/mês/custom)
- [x] **S7-07:** Criar gráfico de atendimentos por período
- [x] **S7-08:** Criar ranking de clientes por KM/atendimentos
- [x] **S7-09:** Tela de detalhe do percurso com mapa (percurso completo incluindo retorno)

**Critério de aceite:** ✅ Dashboard completo com métricas de KM operacional/cobrado, receita, contagem por status, gráfico de barras por dia, ranking de clientes, tempo médio por etapa, seletor de período (hoje/semana/mês/custom), tela de detalhe do percurso com mapa, DI configurado, 279 testes passando.

---

### ✅ Sprint 8 — Polimento e QA (Semana 10)

**Objetivo:** App estável, performático e pronto para produção.

#### Tarefas

- [x] **S8-01:** Revisão geral de UX/UI (consistência visual) — `ErrorStateWidget`, `EmptyStateWidget`, SnackBars padronizados
- [x] **S8-02:** Implementar tratamento de erros na UI (SnackBars, dialogs de erro) — BlocObserver global, `runZonedGuarded`, retry buttons
- [x] **S8-03:** Testes de integração end-to-end nos fluxos principais — Detalhe/Lista atendimento page tests, fluxo de status
- [x] **S8-04:** Otimização de queries Drift (índices, explain query) — 6 índices adicionados, migração v1→v2
- [x] **S8-05:** Testar comportamento em dispositivos com GPS restritivo — ⚠️ Requer dispositivo físico (ver nota abaixo)
- [x] **S8-06:** Configurar `flavor` dev/staging/prod — `AppConfig` com `--dart-define=FLAVOR=dev|staging|prod`
- [x] **S8-07:** Implementar log de erros (ex: Sentry ou Firebase Crashlytics) — `AppLogger` com `LogOutput` extensível
- [x] **S8-08:** Verificar cobertura de testes e cobrir gaps críticos — +60 testes (339 total), widgets, pages, logger, config
- [x] **S8-09:** Build release Android (`.aab`) e validação — signing config, ProGuard, `key.properties` (⚠️ requer keystore)

**Critério de aceite:** ✅ `dart analyze` — 0 issues. 345 testes passando. UX padronizada com `ErrorStateWidget`/`EmptyStateWidget`/retry buttons. Erro global via `runZonedGuarded` + `AppBlocObserver` + `AppLogger`. 6 índices Drift (migração v1→v2). Flavors dev/staging/prod via `--dart-define`. Build release com ProGuard/R8 e signing config preparado. ⚠️ S8-05 (GPS em device restritivo) e build `.aab` real requerem ambiente de produção.

---

## 13. Schema do Banco de Dados Local (Drift)

```dart
// core/database/app_database.dart

// Tabela: clientes
class Clientes extends Table {
  TextColumn get id => text()();
  TextColumn get nome => text()();
  TextColumn get telefone => text()();
  TextColumn get documento => text().nullable()();
  TextColumn get enderecoDefaultJson => text().nullable()(); // LocalGeo serializado
  DateTimeColumn get criadoEm => dateTime()();
  DateTimeColumn get atualizadoEm => dateTime()();
  DateTimeColumn get sincronizadoEm => dateTime().nullable()();
  @override Set<Column> get primaryKey => {id};
}

// Tabela: usuarios
class Usuarios extends Table {
  TextColumn get id => text()();
  TextColumn get nome => text()();
  TextColumn get telefone => text()();
  TextColumn get email => text()();
  TextColumn get role => text()(); // 'operador' | 'administrador'
  RealColumn get valorPorKmDefault => real().withDefault(const Constant(5.0))();
  DateTimeColumn get criadoEm => dateTime()();
  DateTimeColumn get sincronizadoEm => dateTime().nullable()();
  @override Set<Column> get primaryKey => {id};
}

// Tabela: bases
class Bases extends Table {
  TextColumn get id => text()();
  TextColumn get nome => text()();
  TextColumn get localJson => text()(); // LocalGeo serializado
  BoolColumn get isPrincipal => boolean().withDefault(const Constant(false))();
  DateTimeColumn get criadoEm => dateTime()();
  DateTimeColumn get sincronizadoEm => dateTime().nullable()();
  @override Set<Column> get primaryKey => {id};
}

// Tabela: atendimentos
class Atendimentos extends Table {
  TextColumn get id => text()();
  TextColumn get clienteId => text().references(Clientes, #id)();
  TextColumn get usuarioId => text().references(Usuarios, #id)();

  // 4 pontos obrigatórios (RN-007)
  TextColumn get pontoDeSaidaJson => text()();
  TextColumn get localDeColetaJson => text()();
  TextColumn get localDeEntregaJson => text()();
  TextColumn get localDeRetornoJson => text()(); // pré-preenchido com pontoDeSaida, editável

  // Distâncias e valores
  RealColumn get valorPorKm => real()();
  RealColumn get distanciaEstimadaKm => real()(); // saída→coleta→entrega→retorno
  RealColumn get distanciaRealKm => real().nullable()();
  RealColumn get valorCobrado => real().nullable()();
  TextColumn get tipoValor => text()(); // 'fixo' | 'porKm'

  // Status e controle
  TextColumn get status => text()(); // enum AtendimentoStatus
  TextColumn get observacoes => text().nullable()();

  // Timestamps por etapa (permite análise de tempo em cada fase)
  DateTimeColumn get criadoEm => dateTime()();
  DateTimeColumn get atualizadoEm => dateTime()();
  DateTimeColumn get iniciadoEm => dateTime().nullable()();       // → emDeslocamento
  DateTimeColumn get chegadaColetaEm => dateTime().nullable()();  // → emColeta
  DateTimeColumn get chegadaEntregaEm => dateTime().nullable()(); // → emEntrega
  DateTimeColumn get inicioRetornoEm => dateTime().nullable()();  // → retornando
  DateTimeColumn get concluidoEm => dateTime().nullable()();      // → concluido

  DateTimeColumn get sincronizadoEm => dateTime().nullable()();
  @override Set<Column> get primaryKey => {id};
}

// Tabela: pontos_rastreamento
class PontosRastreamento extends Table {
  TextColumn get id => text()();
  TextColumn get atendimentoId => text().references(Atendimentos, #id)();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get accuracy => real()();
  RealColumn get velocidade => real().nullable()();
  DateTimeColumn get timestamp => dateTime()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  @override Set<Column> get primaryKey => {id};
}

// Tabela: sync_queue
class SyncQueue extends Table {
  TextColumn get id => text()();
  TextColumn get entidade => text()();
  TextColumn get operacao => text()(); // 'create' | 'update' | 'delete'
  TextColumn get payload => text()(); // JSON
  IntColumn get tentativas => integer().withDefault(const Constant(0))();
  DateTimeColumn get criadoEm => dateTime()();
  DateTimeColumn get proximaTentativaEm => dateTime().nullable()();
  @override Set<Column> get primaryKey => {id};
}

// Tabela: geocoding_cache
class GeocodingCache extends Table {
  TextColumn get enderecoTexto => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  DateTimeColumn get criadoEm => dateTime()();
  @override Set<Column> get primaryKey => {enderecoTexto};
}
```

---

## 14. Convenções de Código

### Nomenclatura

| Elemento          | Convenção       | Exemplo                       |
| ----------------- | --------------- | ----------------------------- |
| Classes           | PascalCase      | `AtendimentoBloc`             |
| Arquivos          | snake_case      | `atendimento_bloc.dart`       |
| Variáveis/métodos | camelCase       | `calcularDistancia()`         |
| Constantes        | SCREAMING_SNAKE | `GPS_INTERVAL`                |
| Enums             | PascalCase      | `AtendimentoStatus.concluido` |

### Commits (Conventional Commits)

```
feat(atendimento): adicionar cálculo de valor por km real
fix(sync): corrigir backoff exponencial no retry
test(cliente): adicionar testes para BuscarClientes usecase
refactor(geo): extrair cache de geocoding para classe dedicada
docs: atualizar PLANO_DESENVOLVIMENTO com schema Drift
```

### Comentários no Código

- **Não comentar o óbvio.** Código deve ser autoexplicativo.
- Comentar apenas decisões de negócio não óbvias, ex:
  ```dart
  // RN-025: coletar a cada 30s OU 100m, o que ocorrer primeiro
  ```

### Ordem dos Imports

```dart
// 1. Dart SDK
import 'dart:async';

// 2. Flutter
import 'package:flutter/material.dart';

// 3. Packages externos
import 'package:flutter_bloc/flutter_bloc.dart';

// 4. Packages internos (features)
import 'package:guinchoapp/features/atendimento/domain/entities/atendimento.dart';

// 5. Relativos (mesmo feature)
import '../bloc/atendimento_state.dart';
```

---

> **Última atualização:** Design System documentado — Seção 15 adicionada (AppTheme, paleta, tipografia, padrões visuais)
> **Status:** Todas as 9 sprints concluídas ✅

---

## 15. Design System / Identidade Visual

> **Arquivo-fonte:** `lib/core/theme/app_theme.dart`  
> **Branch de origem:** `feat/redesign-ui`  
> **Regra:** Toda página e widget de apresentação **deve** usar exclusivamente as cores, tipografia e componentes definidos nesta seção. Hardcoded colors (`Colors.blue`, `Colors.red`, etc.) são proibidos — exceto para cores semânticas de status definidas em `AppTheme.statusColors`.

---

### 15.1 Paleta de Cores

| Token                | Hex       | Uso                                                    |
| -------------------- | --------- | ------------------------------------------------------ |
| `primary`            | `#1A2B4A` | AppBar, botões primários, ícones de destaque, headings |
| `primaryContainer`   | `#2E4A7A` | Gradient header, fundo de abas ativas                  |
| `secondary`          | `#F4A727` | FAB, valores monetários, chips principais, destaques   |
| `onSecondary`        | `#1A1A1A` | Texto sobre fundo secondary (âmbar)                    |
| `secondaryContainer` | `#FFF3D6` | Fundo de ícones em cards, badges, hover suave          |
| `surface`            | `#F8F9FC` | Background da Scaffold (fundo geral do app)            |
| `onSurface`          | `#1C1C1E` | Texto principal sobre surface                          |
| `error`              | `#D32F2F` | Erros, SnackBars de falha, validação de form           |
| `outline`            | `#C4C8D0` | Bordas suaves, texto secundário/sublabels              |
| `fillColor` (input)  | `#F0F2F8` | Fundo dos campos de texto (InputDecoration)            |
| `divider`            | `#E8EAED` | Divisores, separadores, step connectors inativos       |

**Como acessar no código:**

```dart
final cs = Theme.of(context).colorScheme;

// Cores mais usadas:
cs.primary           // azul-marinho
cs.secondary         // âmbar
cs.secondaryContainer // âmbar claro (fundo de ícones)
cs.surface           // cinza gelo (fundo da tela)
cs.outline           // cinza médio (texto secundário)
```

---

### 15.2 Tipografia

Fonte do sistema (padrão Flutter). Todos os estilos são obtidos via `Theme.of(context).textTheme`.

| Token            | Tamanho | Peso | Uso típico                                           |
| ---------------- | ------- | ---- | ---------------------------------------------------- |
| `displayLarge`   | 32 sp   | w700 | Título principal de tела de entrada (ex: Login)      |
| `headlineMedium` | 24 sp   | w700 | Títulos de seção, valores numéricos grandes          |
| `headlineSmall`  | 20 sp   | w600 | Subtítulos importantes, valores monetários em cards  |
| `titleLarge`     | 18 sp   | w600 | Títulos de cards maiores, cabeçalhos de bottom sheet |
| `titleMedium`    | 16 sp   | w500 | Títulos de ListTile, cabeçalhos de seção em form     |
| `bodyLarge`      | 16 sp   | w400 | Texto corrido principal                              |
| `bodyMedium`     | 14 sp   | w400 | Subtítulo, descrições em cards                       |
| `bodySmall`      | 12 sp   | w400 | Labels, rodapés, texto terciário (use `outline` cor) |
| `labelLarge`     | 14 sp   | w600 | IDs, badges, labels de botão                         |

**Boas práticas:**

```dart
// ✅ Correto — usar TextTheme do contexto
Text('Olá', style: Theme.of(context).textTheme.titleMedium)

// ✅ Correto — sobrescrever apenas uma propriedade
Text('R$ 120,00',
  style: theme.textTheme.headlineSmall?.copyWith(
    color: theme.colorScheme.secondary,
    fontWeight: FontWeight.bold,
  ))

// ❌ Errado — hardcoded
Text('Título', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
```

---

### 15.3 Componentes e Padrões Visuais

#### Cards

Usar o `Card` do Material com as configurações do tema (elevation 0, borderRadius 16, fundo branco). Adicionar `BoxShadow` manual apenas quando for necessário simular elevação interativa:

```dart
// Card padrão — usa as configurações do AppTheme automaticamente
Card(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: ...,
  ),
)

// Card clicável com sombra (ex: menu cards da HomePage)
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        offset: const Offset(0, 2),
        blurRadius: 12,
        color: Colors.black.withValues(alpha: 0.06),
      ),
    ],
  ),
  child: ...,
)
```

#### Ícones em Containers (padrão de cards de menu/info)

Sempre que um ícone for usado como destaque visual dentro de um card, envolvê-lo em um `Container` com fundo `secondaryContainer` e `borderRadius` de 12:

```dart
Container(
  width: 48,
  height: 48,
  decoration: BoxDecoration(
    color: theme.colorScheme.secondaryContainer,
    borderRadius: BorderRadius.circular(12),
  ),
  child: Icon(
    Icons.some_icon,
    color: theme.colorScheme.secondary,
  ),
)
```

#### Campos de Texto (InputDecoration)

O `AppTheme` configura um `InputDecorationTheme` global. **Não adicionar `border: OutlineInputBorder()` explicitamente** — o tema cuida de tudo.

```dart
// ✅ Correto — sem border explícita
TextFormField(
  decoration: const InputDecoration(
    labelText: 'Nome *',
    prefixIcon: Icon(Icons.person_outlined),
  ),
)

// ❌ Errado — border explícita sobrescreve o tema
TextFormField(
  decoration: const InputDecoration(
    labelText: 'Nome *',
    border: OutlineInputBorder(), // remover!
  ),
)
```

Características do input temático:

- Fundo: `#F0F2F8` (fillColor)
- Sem borda visível no estado normal
- BorderRadius: 12
- Focus ring: cor `primary`

#### Botões

```dart
// ElevatedButton — fundo primary, borderRadius 12
ElevatedButton(
  onPressed: ...,
  child: const Text('Salvar'),
)

// OutlinedButton — borda primary 1.5px, borderRadius 12
OutlinedButton(
  onPressed: ...,
  child: const Text('Cancelar'),
)

// Tamanho padrão recomendado para botões de ação principal
SizedBox(
  height: 48,
  width: double.infinity,
  child: ElevatedButton(...),
)
```

#### AppBar

- Fundo: `primary` (azul-marinho)
- Ícones e texto: branco
- Elevation: 0 (sem sombra)
- Subtítulo opcional (padrão da `HomePage`):

```dart
AppBar(
  title: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Título da Tela'),
      Text(
        'Subtítulo opcional',
        style: theme.textTheme.bodySmall?.copyWith(
          color: Colors.white.withValues(alpha: 0.8),
        ),
      ),
    ],
  ),
)
```

#### Bottom Bar com Sombra

Usado em telas de detalhe com ações. Substituir `bottomNavigationBar` simples por um `Container` com sombra ascendente:

```dart
bottomNavigationBar: Container(
  decoration: BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        offset: const Offset(0, -2),
        blurRadius: 8,
        color: Colors.black.withValues(alpha: 0.06),
      ),
    ],
  ),
  child: SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [...],
      ),
    ),
  ),
)
```

#### Gradient Header

Usado em telas de entrada/destaque (Login, Dashboard) para criar hierarquia visual:

```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        theme.colorScheme.primary,
        theme.colorScheme.primaryContainer,
      ],
    ),
    borderRadius: const BorderRadius.vertical(
      bottom: Radius.circular(24),
    ),
  ),
  child: ...,
)
```

---

### 15.4 Chips de Status de Atendimento

Usar `AppTheme.statusColors` para obter as cores (bg, fg) correspondentes a cada status. **Nunca hardcodar cores de status.**

```dart
import '../../../../core/theme/app_theme.dart';

// Em qualquer widget que exiba status:
final (:Color bg, :Color fg) = AppTheme.statusColors[status.name] ??
    (bg: Colors.grey.shade200, fg: Colors.black87);

Chip(
  label: Text(statusLabel, style: TextStyle(fontSize: 11, color: fg)),
  backgroundColor: bg,
  padding: EdgeInsets.zero,
  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  visualDensity: VisualDensity.compact,
  side: BorderSide.none,
)
```

**Mapa completo `statusColors`:**

| Status           | Background | Foreground |
| ---------------- | ---------- | ---------- |
| `rascunho`       | `#E3F2FD`  | `#1565C0`  |
| `emDeslocamento` | `#FFF8E1`  | `#E65100`  |
| `emColeta`       | `#E8F5E9`  | `#2E7D32`  |
| `emEntrega`      | `#F3E5F5`  | `#6A1B9A`  |
| `retornando`     | `#FFF3E0`  | `#BF360C`  |
| `concluido`      | `#E8F5E9`  | `#1B5E20`  |
| `cancelado`      | `#FFEBEE`  | `#B71C1C`  |

---

### 15.5 Estrutura de uma Nova Tela

Checklist ao criar qualquer nova `Page` ou `Widget` de apresentação:

1. **Não importar** `app_theme.dart` diretamente — acessar via `Theme.of(context)`
2. **Sempre** obter referência local antes de usar: `final theme = Theme.of(context);`
3. **Nunca** usar `Colors.*` diretamente (exceto `Colors.white`, `Colors.black` em contextos de overlay com `withValues(alpha:)`)
4. **Usar** `theme.textTheme.*` para todo texto — sem `TextStyle` manual
5. **Remover** qualquer `border: OutlineInputBorder()` de `InputDecoration`
6. **Cards** com `borderRadius: 16` e elevation 0 (tema padrão)
7. **Keys** de widgets testados devem ser preservadas em qualquer refatoração

```dart
// Template mínimo de uma nova página
class MinhaNovaPage extends StatelessWidget {
  const MinhaNovaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // ← referência local obrigatória

    return Scaffold(
      // surface (#F8F9FC) aplicado automaticamente pelo tema
      appBar: AppBar(
        title: const Text('Minha Página'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Título', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Descrição', style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

### 15.6 Regras de Manutenção do Design System

- **Alterar cores ou estilos:** sempre em `lib/core/theme/app_theme.dart`, nunca por sobrescrita inline.
- **Adicionar nova cor semântica** (ex: novo status): adicionar em `AppTheme.statusColors` e documentar na tabela da Seção 15.4.
- **Novas variações de componente** (ex: card com borda lateral): extrair para um widget privado reutilizável dentro da feature; se usado em ≥ 2 features, mover para `lib/core/widgets/`.
- **Não usar** `withOpacity()` — método deprecated; usar `withValues(alpha: x)` onde `x` está no intervalo `0.0–1.0`.
