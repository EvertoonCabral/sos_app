# GuinchoApp SOS — Guia de Desenvolvimento do Back-End

> **Stack:** .NET 8+ · CQRS + MediatR · Unit of Work · Generic Repository · Entity Framework Core  
> **Natureza:** API REST para aplicação mobile **Offline-First**  
> **Gerado a partir do mapeamento completo do app Flutter em 11/03/2026**

---

## Índice

1. [Visão Geral da Arquitetura](#1-visão-geral-da-arquitetura)
2. [Estrutura do Projeto](#2-estrutura-do-projeto)
3. [Entidades e Modelagem do Banco](#3-entidades-e-modelagem-do-banco)
4. [Enums](#4-enums)
5. [DTOs e Contratos da API](#5-dtos-e-contratos-da-api)
6. [Endpoints da API](#6-endpoints-da-api)
7. [Commands (CQRS — Escrita)](#7-commands-cqrs--escrita)
8. [Queries (CQRS — Leitura)](#8-queries-cqrs--leitura)
9. [Generic Repository e Unit of Work](#9-generic-repository-e-unit-of-work)
10. [Sincronização Offline-First](#10-sincronização-offline-first)
11. [Autenticação e Autorização](#11-autenticação-e-autorização)
12. [Regras de Negócio (RN)](#12-regras-de-negócio-rn)
13. [Validações (FluentValidation)](#13-validações-fluentvalidation)
14. [Migrations EF Core](#14-migrations-ef-core)
15. [Testes](#15-testes)
16. [Deploy e Configuração](#16-deploy-e-configuração)

---

## 1. Visão Geral da Arquitetura

```
┌─────────────────────────────────────────────────────────┐
│                    Flutter App (Offline-First)           │
│  ┌──────────┐  ┌──────────┐  ┌──────────────────────┐   │
│  │ SQLite   │  │  Sync    │  │  HTTP Client (Dio)   │   │
│  │ (Drift)  │  │  Queue   │──│  Bearer Token Auth   │   │
│  └──────────┘  └──────────┘  └──────────┬───────────┘   │
└────────────────────────────────────────────┼─────────────┘
                                            │ REST/JSON
┌───────────────────────────────────────────┼─────────────┐
│                    .NET 8 Web API         │             │
│  ┌─────────────────────────────┐          │             │
│  │        Controllers          │◄─────────┘             │
│  └──────────┬──────────────────┘                        │
│  ┌──────────▼──────────────────┐                        │
│  │   MediatR (CQRS Pipeline)  │                        │
│  │  Commands │ Queries         │                        │
│  └──────────┬──────────────────┘                        │
│  ┌──────────▼──────────────────┐                        │
│  │   Application Services      │                        │
│  │   Validators (Fluent)       │                        │
│  └──────────┬──────────────────┘                        │
│  ┌──────────▼──────────────────┐                        │
│  │   Domain (Entities/Enums)   │                        │
│  └──────────┬──────────────────┘                        │
│  ┌──────────▼──────────────────┐                        │
│  │   Infrastructure            │                        │
│  │   EF Core + Unit of Work    │                        │
│  │   Generic Repository        │                        │
│  └──────────┬──────────────────┘                        │
│             │                                           │
│  ┌──────────▼──────────────────┐                        │
│  │   SQL Server / PostgreSQL   │                        │
│  └─────────────────────────────┘                        │
└─────────────────────────────────────────────────────────┘
```

### Princípios

| Princípio              | Aplicação                                                                                                                             |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| **CQRS**               | Commands para escrita, Queries para leitura via MediatR                                                                               |
| **Unit of Work**       | `IUnitOfWork` wrapping `DbContext.SaveChangesAsync()` — garante transação atômica                                                     |
| **Generic Repository** | `IRepository<T>` para CRUD base; repositórios específicos herdam e adicionam métodos                                                  |
| **Offline-First**      | O servidor é o **sistema de registro**. O app envia dados quando reconecta. Conflitos resolvidos por `AtualizadoEm` (last-write-wins) |

---

## 2. Estrutura do Projeto

```
src/
├── GuinchoApp.API/                    # Web API (Controllers, Middlewares, Program.cs)
│   ├── Controllers/
│   │   ├── AuthController.cs
│   │   ├── ClientesController.cs
│   │   ├── AtendimentosController.cs
│   │   ├── BasesController.cs
│   │   ├── RastreamentoController.cs
│   │   ├── DashboardController.cs
│   │   └── SyncController.cs
│   ├── Middlewares/
│   │   └── ExceptionMiddleware.cs
│   └── Program.cs
│
├── GuinchoApp.Application/            # CQRS Commands, Queries, DTOs, Validators
│   ├── Common/
│   │   ├── Interfaces/
│   │   │   ├── IUnitOfWork.cs
│   │   │   ├── IRepository.cs
│   │   │   └── IJwtService.cs
│   │   ├── Behaviors/
│   │   │   ├── ValidationBehavior.cs
│   │   │   └── LoggingBehavior.cs
│   │   └── Mappings/
│   │       └── MappingProfile.cs
│   ├── Auth/
│   │   ├── Commands/
│   │   │   └── LoginCommand.cs
│   │   ├── Queries/
│   │   │   └── GetUsuarioAtualQuery.cs
│   │   └── DTOs/
│   │       ├── LoginRequest.cs
│   │       ├── LoginResponse.cs
│   │       └── UsuarioDto.cs
│   ├── Clientes/
│   │   ├── Commands/
│   │   │   ├── CriarClienteCommand.cs
│   │   │   └── AtualizarClienteCommand.cs
│   │   ├── Queries/
│   │   │   ├── BuscarClientesQuery.cs
│   │   │   └── ObterClientePorIdQuery.cs
│   │   ├── DTOs/
│   │   │   └── ClienteDto.cs
│   │   └── Validators/
│   │       ├── CriarClienteValidator.cs
│   │       └── AtualizarClienteValidator.cs
│   ├── Atendimentos/
│   │   ├── Commands/
│   │   │   ├── CriarAtendimentoCommand.cs
│   │   │   ├── AtualizarStatusCommand.cs
│   │   │   └── AtualizarAtendimentoCommand.cs
│   │   ├── Queries/
│   │   │   ├── ListarAtendimentosQuery.cs
│   │   │   └── ObterAtendimentoPorIdQuery.cs
│   │   ├── DTOs/
│   │   │   ├── AtendimentoDto.cs
│   │   │   └── LocalGeoDto.cs
│   │   └── Validators/
│   │       ├── CriarAtendimentoValidator.cs
│   │       └── AtualizarStatusValidator.cs
│   ├── Bases/
│   │   ├── Commands/
│   │   │   ├── CriarBaseCommand.cs
│   │   │   └── DefinirBasePrincipalCommand.cs
│   │   ├── Queries/
│   │   │   └── ListarBasesQuery.cs
│   │   └── DTOs/
│   │       └── BaseDto.cs
│   ├── Rastreamento/
│   │   ├── Commands/
│   │   │   ├── RegistrarPontosCommand.cs
│   │   │   └── MarcarSincronizadosCommand.cs
│   │   ├── Queries/
│   │   │   └── ObterPercursoQuery.cs
│   │   └── DTOs/
│   │       └── PontoRastreamentoDto.cs
│   ├── Dashboard/
│   │   ├── Queries/
│   │   │   ├── ObterResumoPeriodoQuery.cs
│   │   │   ├── ObterKmPorClienteQuery.cs
│   │   │   ├── ObterTempoPorEtapaQuery.cs
│   │   │   └── ObterAtendimentosPorDiaQuery.cs
│   │   └── DTOs/
│   │       ├── ResumoPeriodoDto.cs
│   │       ├── ResumoClienteDto.cs
│   │       └── TempoPorEtapaDto.cs
│   └── Sync/
│       ├── Commands/
│       │   └── ProcessarSyncBatchCommand.cs
│       └── DTOs/
│           ├── SyncPushRequest.cs
│           └── SyncPullResponse.cs
│
├── GuinchoApp.Domain/                 # Entidades, Enums, Value Objects
│   ├── Entities/
│   │   ├── EntityBase.cs
│   │   ├── Usuario.cs
│   │   ├── Cliente.cs
│   │   ├── Atendimento.cs
│   │   ├── Base.cs
│   │   └── PontoRastreamento.cs
│   ├── Enums/
│   │   ├── AtendimentoStatus.cs
│   │   ├── TipoValor.cs
│   │   └── UsuarioRole.cs
│   └── ValueObjects/
│       └── LocalGeo.cs
│
├── GuinchoApp.Infrastructure/         # EF Core, Repositories, JWT, Migrations
│   ├── Data/
│   │   ├── AppDbContext.cs
│   │   ├── UnitOfWork.cs
│   │   └── Configurations/
│   │       ├── UsuarioConfiguration.cs
│   │       ├── ClienteConfiguration.cs
│   │       ├── AtendimentoConfiguration.cs
│   │       ├── BaseConfiguration.cs
│   │       └── PontoRastreamentoConfiguration.cs
│   ├── Repositories/
│   │   ├── GenericRepository.cs
│   │   ├── ClienteRepository.cs
│   │   ├── AtendimentoRepository.cs
│   │   ├── BaseRepository.cs
│   │   ├── PontoRastreamentoRepository.cs
│   │   └── UsuarioRepository.cs
│   ├── Services/
│   │   └── JwtService.cs
│   └── Migrations/
│
└── GuinchoApp.Tests/                  # Unit + Integration tests
    ├── Application/
    ├── Domain/
    └── Infrastructure/
```

---

## 3. Entidades e Modelagem do Banco

### 3.1 EntityBase (classe abstrata)

```csharp
public abstract class EntityBase
{
    public string Id { get; set; } = Guid.NewGuid().ToString();
    public DateTime CriadoEm { get; set; } = DateTime.UtcNow;
    public DateTime AtualizadoEm { get; set; } = DateTime.UtcNow;
}
```

> O `Id` é `string` (UUID) gerado pelo **app mobile** para permitir criação offline. O servidor aceita o ID enviado.

---

### 3.2 Usuario

```csharp
public class Usuario : EntityBase
{
    public string Nome { get; set; }
    public string Telefone { get; set; }
    public string Email { get; set; }
    public string SenhaHash { get; set; }          // BCrypt hash – NÃO existe no app
    public UsuarioRole Role { get; set; }           // Operador | Administrador
    public double ValorPorKmDefault { get; set; } = 5.0;

    // Navigation
    public ICollection<Atendimento> Atendimentos { get; set; }
}
```

**EF Configuration:**

```csharp
builder.HasIndex(u => u.Email).IsUnique();
builder.Property(u => u.Role).HasConversion<string>().HasMaxLength(20);
builder.Property(u => u.SenhaHash).HasMaxLength(200);
```

---

### 3.3 Cliente

```csharp
public class Cliente : EntityBase
{
    public string Nome { get; set; }
    public string Telefone { get; set; }
    public string? Documento { get; set; }
    public LocalGeo? EnderecoDefault { get; set; }  // Owned Type ou JSON column
    public DateTime? SincronizadoEm { get; set; }

    // Navigation
    public ICollection<Atendimento> Atendimentos { get; set; }
}
```

**EF Configuration:**

```csharp
builder.HasIndex(c => c.Nome);
builder.HasIndex(c => c.Telefone);
builder.Property(c => c.Documento).HasMaxLength(20);
builder.OwnsOne(c => c.EnderecoDefault, geo =>
{
    geo.Property(g => g.EnderecoTexto).HasMaxLength(500);
    geo.Property(g => g.Complemento).HasMaxLength(200);
});
```

---

### 3.4 Atendimento

```csharp
public class Atendimento : EntityBase
{
    // Relacionamentos
    public string ClienteId { get; set; }
    public Cliente Cliente { get; set; }
    public string UsuarioId { get; set; }
    public Usuario Usuario { get; set; }

    // 4 Pontos de Localização (RN-007)
    public LocalGeo PontoDeSaida { get; set; }
    public LocalGeo LocalDeColeta { get; set; }
    public LocalGeo LocalDeEntrega { get; set; }
    public LocalGeo LocalDeRetorno { get; set; }

    // Distância e Valor
    public double DistanciaEstimadaKm { get; set; }
    public double? DistanciaRealKm { get; set; }
    public double ValorPorKm { get; set; }
    public double? ValorCobrado { get; set; }
    public TipoValor TipoValor { get; set; }        // Fixo | PorKm

    // Status e Ciclo
    public AtendimentoStatus Status { get; set; } = AtendimentoStatus.Rascunho;
    public string? Observacoes { get; set; }

    // Timestamps do Ciclo de Vida
    public DateTime? IniciadoEm { get; set; }        // → EmDeslocamento
    public DateTime? ChegadaColetaEm { get; set; }   // → EmColeta
    public DateTime? ChegadaEntregaEm { get; set; }  // → EmEntrega
    public DateTime? InicioRetornoEm { get; set; }   // → Retornando
    public DateTime? ConcluidoEm { get; set; }       // → Concluido
    public DateTime? SincronizadoEm { get; set; }

    // Navigation
    public ICollection<PontoRastreamento> PontosRastreamento { get; set; }
}
```

**EF Configuration:**

```csharp
builder.HasOne(a => a.Cliente).WithMany(c => c.Atendimentos)
    .HasForeignKey(a => a.ClienteId).OnDelete(DeleteBehavior.Restrict);
builder.HasOne(a => a.Usuario).WithMany(u => u.Atendimentos)
    .HasForeignKey(a => a.UsuarioId).OnDelete(DeleteBehavior.Restrict);

builder.Property(a => a.Status).HasConversion<string>().HasMaxLength(20);
builder.Property(a => a.TipoValor).HasConversion<string>().HasMaxLength(10);
builder.Property(a => a.Observacoes).HasMaxLength(1000);

// Owned Types para os 4 LocalGeo
builder.OwnsOne(a => a.PontoDeSaida,   geo => ConfigureLocalGeo(geo, "Saida"));
builder.OwnsOne(a => a.LocalDeColeta,  geo => ConfigureLocalGeo(geo, "Coleta"));
builder.OwnsOne(a => a.LocalDeEntrega, geo => ConfigureLocalGeo(geo, "Entrega"));
builder.OwnsOne(a => a.LocalDeRetorno, geo => ConfigureLocalGeo(geo, "Retorno"));

// Indexes (performance — espelham os do Drift)
builder.HasIndex(a => a.Status);
builder.HasIndex(a => a.ClienteId);
builder.HasIndex(a => a.CriadoEm);
```

---

### 3.5 Base (Filial/Garagem)

```csharp
public class Base : EntityBase
{
    public string Nome { get; set; }
    public LocalGeo Local { get; set; }             // Owned Type
    public bool IsPrincipal { get; set; }
    public DateTime? SincronizadoEm { get; set; }
}
```

---

### 3.6 PontoRastreamento

```csharp
public class PontoRastreamento : EntityBase
{
    public string AtendimentoId { get; set; }
    public Atendimento Atendimento { get; set; }

    public double Latitude { get; set; }
    public double Longitude { get; set; }
    public double Accuracy { get; set; }             // metros
    public double? Velocidade { get; set; }          // m/s
    public DateTime Timestamp { get; set; }          // Quando o GPS coletou
}
```

**EF Configuration:**

```csharp
builder.HasOne(p => p.Atendimento).WithMany(a => a.PontosRastreamento)
    .HasForeignKey(p => p.AtendimentoId).OnDelete(DeleteBehavior.Cascade);
builder.HasIndex(p => p.AtendimentoId);
builder.HasIndex(p => p.Timestamp);
```

> `PontoRastreamento` não precisa de `Synced` no servidor — se chegou à API, está sincronizado.

---

### 3.7 LocalGeo (Value Object / Owned Type)

```csharp
public class LocalGeo
{
    public string EnderecoTexto { get; set; }
    public double Latitude { get; set; }
    public double Longitude { get; set; }
    public string? Complemento { get; set; }
}
```

Mapeado como **Owned Type** no EF Core — colunas ficam na tabela pai com prefixo.

---

### Diagrama ER

```
┌─────────────┐       ┌──────────────────┐       ┌────────────────────┐
│  Usuarios   │       │   Atendimentos   │       │    Clientes        │
├─────────────┤       ├──────────────────┤       ├────────────────────┤
│ Id (PK)     │──1:N──│ UsuarioId (FK)   │  N:1──│ Id (PK)            │
│ Nome        │       │ ClienteId (FK)   │───────│ Nome               │
│ Email (UQ)  │       │ Status           │       │ Telefone           │
│ SenhaHash   │       │ TipoValor        │       │ Documento?         │
│ Role        │       │ ValorPorKm       │       │ EnderecoDefault?   │
│ ValorPorKm  │       │ ValorCobrado?    │       │ CriadoEm           │
│ CriadoEm    │       │ DistEstimada     │       │ AtualizadoEm       │
└─────────────┘       │ DistReal?        │       │ SincronizadoEm?    │
                      │ PontoDeSaida_*   │       └────────────────────┘
                      │ LocalDeColeta_*  │
                      │ LocalDeEntrega_* │       ┌────────────────────┐
                      │ LocalDeRetorno_* │       │    Bases           │
                      │ Observacoes?     │       ├────────────────────┤
                      │ IniciadoEm?      │       │ Id (PK)            │
                      │ ChegadaColeta?   │       │ Nome               │
                      │ ChegadaEntrega?  │       │ Local_*            │
                      │ InicioRetorno?   │       │ IsPrincipal        │
                      │ ConcluidoEm?     │       │ CriadoEm           │
                      │ CriadoEm         │       │ AtualizadoEm       │
                      │ AtualizadoEm     │       │ SincronizadoEm?    │
                      │ SincronizadoEm?  │       └────────────────────┘
                      └────────┬─────────┘
                               │ 1:N
                      ┌────────▼─────────┐
                      │PontosRastreamento│
                      ├──────────────────┤
                      │ Id (PK)          │
                      │ AtendimentoId FK │
                      │ Latitude         │
                      │ Longitude        │
                      │ Accuracy         │
                      │ Velocidade?      │
                      │ Timestamp        │
                      │ CriadoEm         │
                      └──────────────────┘
```

---

## 4. Enums

```csharp
public enum AtendimentoStatus
{
    Rascunho,
    EmDeslocamento,
    EmColeta,
    EmEntrega,
    Retornando,
    Concluido,
    Cancelado
}

public enum TipoValor
{
    Fixo,
    PorKm
}

public enum UsuarioRole
{
    Operador,
    Administrador
}
```

### Matriz de Transição de Status (validar no servidor)

| Status Atual   | Transições Permitidas     |
| -------------- | ------------------------- |
| Rascunho       | EmDeslocamento, Cancelado |
| EmDeslocamento | EmColeta, Cancelado       |
| EmColeta       | EmEntrega, Cancelado      |
| EmEntrega      | Retornando, Cancelado     |
| Retornando     | Concluido, Cancelado      |
| Concluido      | _(nenhuma — final)_       |
| Cancelado      | _(nenhuma — final)_       |

---

## 5. DTOs e Contratos da API

### 5.1 LocalGeoDto

```csharp
public record LocalGeoDto(
    string EnderecoTexto,
    double Latitude,
    double Longitude,
    string? Complemento
);
```

### 5.2 Auth DTOs

```csharp
// POST /api/auth/login
public record LoginRequest(string Email, string Senha);

public record LoginResponse(string Token, UsuarioDto Usuario);

public record UsuarioDto(
    string Id,
    string Nome,
    string Telefone,
    string Email,
    string Role,             // "operador" | "administrador"
    double ValorPorKmDefault,
    DateTime CriadoEm,
    DateTime? SincronizadoEm
);
```

### 5.3 Cliente DTOs

```csharp
public record ClienteDto(
    string Id,
    string Nome,
    string Telefone,
    string? Documento,
    LocalGeoDto? EnderecoDefault,
    DateTime CriadoEm,
    DateTime AtualizadoEm,
    DateTime? SincronizadoEm
);

// Input para criar/atualizar
public record CriarClienteRequest(
    string Id,               // UUID gerado pelo app
    string Nome,
    string Telefone,
    string? Documento,
    LocalGeoDto? EnderecoDefault
);

public record AtualizarClienteRequest(
    string Nome,
    string Telefone,
    string? Documento,
    LocalGeoDto? EnderecoDefault,
    DateTime AtualizadoEm    // Para conflict resolution
);
```

### 5.4 Atendimento DTOs

```csharp
public record AtendimentoDto(
    string Id,
    string ClienteId,
    string UsuarioId,
    string? ClienteNome,     // Incluir para exibição
    LocalGeoDto PontoDeSaida,
    LocalGeoDto LocalDeColeta,
    LocalGeoDto LocalDeEntrega,
    LocalGeoDto LocalDeRetorno,
    double DistanciaEstimadaKm,
    double? DistanciaRealKm,
    double ValorPorKm,
    double? ValorCobrado,
    string TipoValor,        // "fixo" | "porKm"
    string Status,            // Nome do enum em camelCase
    string? Observacoes,
    DateTime CriadoEm,
    DateTime AtualizadoEm,
    DateTime? IniciadoEm,
    DateTime? ChegadaColetaEm,
    DateTime? ChegadaEntregaEm,
    DateTime? InicioRetornoEm,
    DateTime? ConcluidoEm,
    DateTime? SincronizadoEm
);

public record CriarAtendimentoRequest(
    string Id,                // UUID do app
    string ClienteId,
    string UsuarioId,
    LocalGeoDto PontoDeSaida,
    LocalGeoDto LocalDeColeta,
    LocalGeoDto LocalDeEntrega,
    LocalGeoDto LocalDeRetorno,
    double ValorPorKm,
    double DistanciaEstimadaKm,
    string TipoValor,
    double? ValorCobrado,     // Se tipo fixo
    string? Observacoes
);

public record AtualizarStatusRequest(
    string NovoStatus,
    DateTime AtualizadoEm,
    double? DistanciaRealKm,  // Enviado ao concluir (tipo porKm)
    double? ValorCobrado      // Enviado ao concluir
);
```

### 5.5 Base DTOs

```csharp
public record BaseDto(
    string Id,
    string Nome,
    LocalGeoDto Local,
    bool IsPrincipal,
    DateTime CriadoEm,
    DateTime? SincronizadoEm
);

public record CriarBaseRequest(
    string Id,
    string Nome,
    LocalGeoDto Local,
    bool IsPrincipal
);
```

### 5.6 Rastreamento DTOs

```csharp
public record PontoRastreamentoDto(
    string Id,
    string AtendimentoId,
    double Latitude,
    double Longitude,
    double Accuracy,
    double? Velocidade,
    DateTime Timestamp
);

// Batch para eficiência (pode enviar centenas de pontos de uma vez)
public record RegistrarPontosRequest(
    List<PontoRastreamentoDto> Pontos
);
```

### 5.7 Dashboard DTOs

```csharp
public record ResumoPeriodoDto(
    double KmOperacional,
    double KmCobrado,
    double ReceitaTotal,
    int TotalAtendimentos,
    int TotalConcluidos,
    int TotalCancelados,
    int TotalEmAndamento
);

public record ResumoClienteDto(
    string ClienteId,
    string ClienteNome,
    int TotalAtendimentos,
    double TotalKm,
    double TotalReceita
);

public record TempoPorEtapaDto(
    double MediaMinutosAteColeta,
    double MediaMinutosColetaEntrega,
    double MediaMinutosEntregaRetorno,
    double MediaMinutosRetornoBase,
    int TotalAnalisados
);

public record AtendimentosPorDiaDto(
    DateTime Data,
    int Quantidade
);
```

### 5.8 Sync DTOs

```csharp
// App envia batch de operações pendentes
public record SyncPushRequest(
    List<SyncOperationDto> Operacoes
);

public record SyncOperationDto(
    string Id,                // ID da operação na fila
    string Entidade,          // "cliente" | "atendimento" | "ponto_rastreamento" | "base"
    string Operacao,          // "create" | "update" | "delete"
    string Payload            // JSON serializado do objeto
);

// Servidor responde com resultados + dados atualizados
public record SyncPushResponse(
    List<SyncResultDto> Resultados,
    DateTime ProcessadoEm
);

public record SyncResultDto(
    string OperacaoId,
    bool Sucesso,
    string? Erro
);

// Pull — app pede alterações desde última sync
public record SyncPullResponse(
    List<ClienteDto> Clientes,
    List<AtendimentoDto> Atendimentos,
    List<BaseDto> Bases,
    List<UsuarioDto> Usuarios,
    DateTime SincronizadoEm
);
```

---

## 6. Endpoints da API

### 6.1 Autenticação

| Método | Rota                | Descrição              | Auth |
| ------ | ------------------- | ---------------------- | ---- |
| POST   | `/api/auth/login`   | Login com email/senha  | Não  |
| GET    | `/api/auth/me`      | Retorna usuário logado | Sim  |
| POST   | `/api/auth/refresh` | Renova token JWT       | Sim  |

### 6.2 Clientes

| Método | Rota                      | Descrição                | Auth |
| ------ | ------------------------- | ------------------------ | ---- |
| POST   | `/api/clientes`           | Criar cliente            | Sim  |
| PUT    | `/api/clientes/{id}`      | Atualizar cliente        | Sim  |
| GET    | `/api/clientes/{id}`      | Obter por ID             | Sim  |
| GET    | `/api/clientes?q={query}` | Buscar por nome/telefone | Sim  |
| GET    | `/api/clientes`           | Listar todos             | Sim  |

### 6.3 Atendimentos

| Método | Rota                                | Descrição                | Auth |
| ------ | ----------------------------------- | ------------------------ | ---- |
| POST   | `/api/atendimentos`                 | Criar atendimento        | Sim  |
| PUT    | `/api/atendimentos/{id}`            | Atualizar atendimento    | Sim  |
| PATCH  | `/api/atendimentos/{id}/status`     | Atualizar status         | Sim  |
| GET    | `/api/atendimentos/{id}`            | Obter por ID             | Sim  |
| GET    | `/api/atendimentos?status={status}` | Listar (filtro opcional) | Sim  |

### 6.4 Bases

| Método | Rota                        | Descrição              | Auth        |
| ------ | --------------------------- | ---------------------- | ----------- |
| POST   | `/api/bases`                | Criar base             | Sim (Admin) |
| PUT    | `/api/bases/{id}`           | Atualizar base         | Sim (Admin) |
| POST   | `/api/bases/{id}/principal` | Definir como principal | Sim (Admin) |
| GET    | `/api/bases`                | Listar todas           | Sim         |

### 6.5 Rastreamento

| Método | Rota                                | Descrição                | Auth |
| ------ | ----------------------------------- | ------------------------ | ---- |
| POST   | `/api/rastreamento/pontos`          | Registrar pontos (batch) | Sim  |
| GET    | `/api/rastreamento/{atendimentoId}` | Obter percurso           | Sim  |

### 6.6 Dashboard

| Método | Rota                                       | Descrição         | Auth |
| ------ | ------------------------------------------ | ----------------- | ---- |
| GET    | `/api/dashboard/resumo?inicio={}&fim={}`   | Resumo do período | Sim  |
| GET    | `/api/dashboard/clientes?inicio={}&fim={}` | Ranking clientes  | Sim  |
| GET    | `/api/dashboard/etapas?inicio={}&fim={}`   | Tempo por etapa   | Sim  |
| GET    | `/api/dashboard/diario?inicio={}&fim={}`   | Atendimentos/dia  | Sim  |

### 6.7 Sincronização

| Método | Rota                               | Descrição                   | Auth |
| ------ | ---------------------------------- | --------------------------- | ---- |
| POST   | `/api/sync/push`                   | Envia operações pendentes   | Sim  |
| GET    | `/api/sync/pull?desde={timestamp}` | Puxa atualizações do server | Sim  |

---

## 7. Commands (CQRS — Escrita)

Cada Command implementa `IRequest<T>` do MediatR.

### 7.1 Auth Commands

```csharp
// LoginCommand.cs
public record LoginCommand(string Email, string Senha) : IRequest<LoginResponse>;

public class LoginCommandHandler : IRequestHandler<LoginCommand, LoginResponse>
{
    // 1. Busca usuário por email
    // 2. Verifica BCrypt.Verify(senha, senhaHash)
    // 3. Gera JWT (id, email, role, exp)
    // 4. Retorna { token, usuario }
}
```

### 7.2 Cliente Commands

```csharp
// CriarClienteCommand.cs
public record CriarClienteCommand(
    string Id,
    string Nome,
    string Telefone,
    string? Documento,
    LocalGeoDto? EnderecoDefault,
    DateTime CriadoEm
) : IRequest<ClienteDto>;

public class CriarClienteCommandHandler : IRequestHandler<CriarClienteCommand, ClienteDto>
{
    // 1. Verifica se ID já existe (idempotência — sync pode reenviar)
    //    Se já existe → retorna existente (não duplica)
    // 2. Mapeia para entidade
    // 3. repo.Add(cliente)
    // 4. unitOfWork.SaveChangesAsync()
    // 5. Retorna ClienteDto
}

// AtualizarClienteCommand.cs
public record AtualizarClienteCommand(
    string Id,
    string Nome,
    string Telefone,
    string? Documento,
    LocalGeoDto? EnderecoDefault,
    DateTime AtualizadoEm          // Conflict resolution (RN-036)
) : IRequest<ClienteDto>;

public class AtualizarClienteCommandHandler : IRequestHandler<AtualizarClienteCommand, ClienteDto>
{
    // 1. Busca cliente por ID
    // 2. Compara AtualizadoEm — last-write-wins (RN-036)
    //    Se o do servidor é mais recente → ignora update, retorna versão do servidor
    // 3. Atualiza campos
    // 4. unitOfWork.SaveChangesAsync()
}
```

### 7.3 Atendimento Commands

```csharp
// CriarAtendimentoCommand.cs
public record CriarAtendimentoCommand(
    string Id,
    string ClienteId,
    string UsuarioId,
    LocalGeoDto PontoDeSaida,
    LocalGeoDto LocalDeColeta,
    LocalGeoDto LocalDeEntrega,
    LocalGeoDto LocalDeRetorno,
    double ValorPorKm,
    double DistanciaEstimadaKm,
    string TipoValor,
    double? ValorCobrado,
    string? Observacoes,
    DateTime CriadoEm
) : IRequest<AtendimentoDto>;

// Handler: Idempotente — se ID existe, retorna existente

// AtualizarStatusCommand.cs
public record AtualizarStatusCommand(
    string AtendimentoId,
    string NovoStatus,
    DateTime AtualizadoEm,
    double? DistanciaRealKm,
    double? ValorCobrado
) : IRequest<AtendimentoDto>;

public class AtualizarStatusCommandHandler : IRequestHandler<AtualizarStatusCommand, AtendimentoDto>
{
    // 1. Busca atendimento
    // 2. Valida transição de status (Matrz de Transição)
    // 3. Atualiza timestamp correspondente:
    //    EmDeslocamento → IniciadoEm
    //    EmColeta       → ChegadaColetaEm
    //    EmEntrega      → ChegadaEntregaEm
    //    Retornando     → InicioRetornoEm
    //    Concluido      → ConcluidoEm + DistanciaRealKm + ValorCobrado
    // 4. unitOfWork.SaveChangesAsync()
}

// AtualizarAtendimentoCommand.cs (dados gerais — permitido só em Rascunho)
public record AtualizarAtendimentoCommand(
    string Id,
    // ... todos os campos editáveis
    DateTime AtualizadoEm
) : IRequest<AtendimentoDto>;
```

### 7.4 Base Commands

```csharp
// CriarBaseCommand.cs
public record CriarBaseCommand(
    string Id, string Nome, LocalGeoDto Local, bool IsPrincipal, DateTime CriadoEm
) : IRequest<BaseDto>;

// DefinirBasePrincipalCommand.cs
public record DefinirBasePrincipalCommand(string BaseId) : IRequest<BaseDto>;

// Handler:
// 1. Busca todas as bases → seta IsPrincipal = false
// 2. Seta a base alvo como IsPrincipal = true
// 3. SaveChanges (transação única via UoW)
```

### 7.5 Rastreamento Commands

```csharp
// RegistrarPontosCommand.cs (batch)
public record RegistrarPontosCommand(
    List<PontoRastreamentoDto> Pontos
) : IRequest<int>;  // Retorna quantidade inserida

public class RegistrarPontosCommandHandler : IRequestHandler<RegistrarPontosCommand, int>
{
    // 1. Para cada ponto:
    //    - Verifica se ID já existe (idempotência)
    //    - Se não existe → Add
    // 2. AddRange dos novos
    // 3. unitOfWork.SaveChangesAsync()
    // 4. Retorna count inseridos
}
```

### 7.6 Sync Commands

```csharp
// ProcessarSyncBatchCommand.cs
public record ProcessarSyncBatchCommand(
    List<SyncOperationDto> Operacoes
) : IRequest<SyncPushResponse>;

public class ProcessarSyncBatchCommandHandler : IRequestHandler<ProcessarSyncBatchCommand, SyncPushResponse>
{
    // Para cada operação no batch (ordem cronológica):
    // 1. Deserializa o payload baseado em {entidade}
    // 2. Roteia para o handler correto:
    //    - cliente/create   → CriarClienteCommand
    //    - cliente/update   → AtualizarClienteCommand
    //    - atendimento/*    → CriarAtendimento / AtualizarStatus
    //    - ponto_rastreamento/create → RegistrarPontosCommand
    //    - base/*           → CriarBase / AtualizarBase
    // 3. Cada operação retorna Sucesso ou Erro
    // 4. Retorna lista de resultados
}
```

---

## 8. Queries (CQRS — Leitura)

### 8.1 Leitura Direta (sem regras de negócio)

```csharp
// BuscarClientesQuery.cs
public record BuscarClientesQuery(string? Query) : IRequest<List<ClienteDto>>;
// Handler: usa EF .Where(c => c.Nome.Contains(q) || c.Telefone.Contains(q))

// ListarAtendimentosQuery.cs
public record ListarAtendimentosQuery(AtendimentoStatus? Status) : IRequest<List<AtendimentoDto>>;
// Handler: usa EF com filtro opcional + Include(Cliente) para ClienteNome

// ObterAtendimentoPorIdQuery.cs
public record ObterAtendimentoPorIdQuery(string Id) : IRequest<AtendimentoDto>;

// ObterClientePorIdQuery.cs
public record ObterClientePorIdQuery(string Id) : IRequest<ClienteDto>;

// ListarBasesQuery.cs
public record ListarBasesQuery() : IRequest<List<BaseDto>>;

// ObterPercursoQuery.cs
public record ObterPercursoQuery(string AtendimentoId) : IRequest<List<PontoRastreamentoDto>>;
// Handler: .Where(p => p.AtendimentoId == id).OrderBy(p => p.Timestamp)
```

### 8.2 Dashboard Queries (Agregações)

```csharp
// ObterResumoPeriodoQuery.cs
public record ObterResumoPeriodoQuery(DateTime Inicio, DateTime Fim) : IRequest<ResumoPeriodoDto>;

public class ObterResumoPeriodoQueryHandler : IRequestHandler<ObterResumoPeriodoQuery, ResumoPeriodoDto>
{
    // SELECT from Atendimentos WHERE CriadoEm BETWEEN @inicio AND @fim
    // Calcula:
    //   KmOperacional  = SUM(DistanciaRealKm)   onde DistanciaRealKm != null
    //   KmCobrado      = SUM(DistanciaEstimadaKm) dos concluídos
    //   ReceitaTotal   = SUM(ValorCobrado)       dos concluídos
    //   TotalAtendimentos = COUNT(*)
    //   TotalConcluidos   = COUNT(Status == Concluido)
    //   TotalCancelados   = COUNT(Status == Cancelado)
    //   TotalEmAndamento  = COUNT(Status != Concluido && Status != Cancelado)
}

// ObterKmPorClienteQuery.cs
public record ObterKmPorClienteQuery(DateTime Inicio, DateTime Fim) : IRequest<List<ResumoClienteDto>>;
// Handler: GROUP BY ClienteId com SUM de km/receita, JOIN com Cliente.Nome

// ObterTempoPorEtapaQuery.cs
public record ObterTempoPorEtapaQuery(DateTime Inicio, DateTime Fim) : IRequest<TempoPorEtapaDto>;
// Handler: AVG das diferenças entre timestamps do ciclo de vida (somente concluídos)
//   MediaMinutosAteColeta      = AVG(ChegadaColetaEm - IniciadoEm)
//   MediaMinutosColetaEntrega  = AVG(ChegadaEntregaEm - ChegadaColetaEm)
//   MediaMinutosEntregaRetorno = AVG(InicioRetornoEm - ChegadaEntregaEm)
//   MediaMinutosRetornoBase    = AVG(ConcluidoEm - InicioRetornoEm)

// ObterAtendimentosPorDiaQuery.cs
public record ObterAtendimentosPorDiaQuery(DateTime Inicio, DateTime Fim) : IRequest<List<AtendimentosPorDiaDto>>;
// Handler: GROUP BY ConcluidoEm.Date, COUNT(*)
```

### 8.3 Sync Pull Query

```csharp
// PullSyncQuery.cs
public record PullSyncQuery(DateTime? Desde) : IRequest<SyncPullResponse>;

public class PullSyncQueryHandler : IRequestHandler<PullSyncQuery, SyncPullResponse>
{
    // Retorna todas entidades onde AtualizadoEm > @desde
    // Se @desde == null → retorna tudo (first sync)
    // Inclui: Clientes, Atendimentos, Bases, Usuarios
}
```

---

## 9. Generic Repository e Unit of Work

### 9.1 IRepository\<T\>

```csharp
public interface IRepository<T> where T : EntityBase
{
    Task<T?> GetByIdAsync(string id);
    Task<List<T>> GetAllAsync();
    Task<List<T>> FindAsync(Expression<Func<T, bool>> predicate);
    Task AddAsync(T entity);
    void Update(T entity);
    void Remove(T entity);
    Task<bool> ExistsAsync(string id);
}
```

### 9.2 GenericRepository\<T\>

```csharp
public class GenericRepository<T> : IRepository<T> where T : EntityBase
{
    protected readonly AppDbContext _context;
    protected readonly DbSet<T> _dbSet;

    public GenericRepository(AppDbContext context)
    {
        _context = context;
        _dbSet = context.Set<T>();
    }

    public async Task<T?> GetByIdAsync(string id)
        => await _dbSet.FindAsync(id);

    public async Task<List<T>> GetAllAsync()
        => await _dbSet.ToListAsync();

    public async Task<List<T>> FindAsync(Expression<Func<T, bool>> predicate)
        => await _dbSet.Where(predicate).ToListAsync();

    public async Task AddAsync(T entity)
        => await _dbSet.AddAsync(entity);

    public void Update(T entity)
        => _dbSet.Update(entity);

    public void Remove(T entity)
        => _dbSet.Remove(entity);

    public async Task<bool> ExistsAsync(string id)
        => await _dbSet.AnyAsync(e => e.Id == id);
}
```

### 9.3 Repositórios Específicos

```csharp
// IClienteRepository.cs
public interface IClienteRepository : IRepository<Cliente>
{
    Task<List<Cliente>> BuscarAsync(string query);
    Task<List<Cliente>> GetAllOrderedByNomeAsync();
}

// IAtendimentoRepository.cs
public interface IAtendimentoRepository : IRepository<Atendimento>
{
    Task<List<Atendimento>> ListarPorStatusAsync(AtendimentoStatus? status);
    Task<Atendimento?> GetByIdComClienteAsync(string id);
    Task<List<Atendimento>> GetPorPeriodoAsync(DateTime inicio, DateTime fim);
}

// IPontoRastreamentoRepository.cs
public interface IPontoRastreamentoRepository : IRepository<PontoRastreamento>
{
    Task<List<PontoRastreamento>> GetPorAtendimentoAsync(string atendimentoId);
    Task AddRangeAsync(IEnumerable<PontoRastreamento> pontos);
}

// IBaseRepository.cs
public interface IBaseRepository : IRepository<Base>
{
    Task ResetarPrincipalAsync();  // SET IsPrincipal = false em todas
}

// IUsuarioRepository.cs
public interface IUsuarioRepository : IRepository<Usuario>
{
    Task<Usuario?> GetByEmailAsync(string email);
}
```

### 9.4 IUnitOfWork

```csharp
public interface IUnitOfWork : IDisposable
{
    IClienteRepository Clientes { get; }
    IAtendimentoRepository Atendimentos { get; }
    IPontoRastreamentoRepository PontosRastreamento { get; }
    IBaseRepository Bases { get; }
    IUsuarioRepository Usuarios { get; }

    Task<int> SaveChangesAsync(CancellationToken ct = default);
    Task BeginTransactionAsync();
    Task CommitAsync();
    Task RollbackAsync();
}
```

### 9.5 UnitOfWork Implementation

```csharp
public class UnitOfWork : IUnitOfWork
{
    private readonly AppDbContext _context;
    private IDbContextTransaction? _transaction;

    // Lazy-loaded repositories
    private IClienteRepository? _clientes;
    private IAtendimentoRepository? _atendimentos;
    // ...

    public UnitOfWork(AppDbContext context) => _context = context;

    public IClienteRepository Clientes
        => _clientes ??= new ClienteRepository(_context);

    public IAtendimentoRepository Atendimentos
        => _atendimentos ??= new AtendimentoRepository(_context);

    // ... demais repositórios

    public async Task<int> SaveChangesAsync(CancellationToken ct = default)
        => await _context.SaveChangesAsync(ct);

    public async Task BeginTransactionAsync()
        => _transaction = await _context.Database.BeginTransactionAsync();

    public async Task CommitAsync()
    {
        await _context.SaveChangesAsync();
        if (_transaction != null) await _transaction.CommitAsync();
    }

    public async Task RollbackAsync()
    {
        if (_transaction != null) await _transaction.RollbackAsync();
    }

    public void Dispose()
    {
        _transaction?.Dispose();
        _context.Dispose();
    }
}
```

---

## 10. Sincronização Offline-First

### 10.1 Fluxo Completo

```
┌──────────────────────────────────────────────────────────────┐
│  App Flutter (Offline)                                       │
│                                                              │
│  1. Usuário cria/edita registros → salva no SQLite local     │
│  2. Cada operação gera entrada na sync_queue:                │
│     { entidade, operacao, payload_json, tentativas }         │
│  3. SyncManager monitora conectividade                       │
│  4. Ao conectar → processa fila cronologicamente             │
└──────────────────────────────┬───────────────────────────────┘
                               │
                    POST /api/sync/push
                    {operacoes: [...]}
                               │
┌──────────────────────────────▼───────────────────────────────┐
│  .NET API Server                                             │
│                                                              │
│  1. Recebe batch de operações                                │
│  2. Para cada operação (em ordem cronológica):               │
│     a. Deserializa payload baseado em {entidade}             │
│     b. Verifica se ID já existe (idempotência)               │
│        - Se create e já existe → skip (sucesso)              │
│        - Se update → compara AtualizadoEm (last-write-wins) │
│     c. Persiste no banco                                     │
│  3. Retorna resultados por operação                          │
│  4. App remove da fila local os itens com sucesso            │
└──────────────────────────────────────────────────────────────┘
```

### 10.2 Endpoints de Sync

#### POST `/api/sync/push` — App envia dados ao servidor

```
Request:
{
  "operacoes": [
    {
      "id": "uuid-da-operacao",
      "entidade": "cliente",
      "operacao": "create",
      "payload": "{\"id\":\"uuid\",\"nome\":\"João\",\"telefone\":\"11999\",...}"
    },
    {
      "id": "uuid-2",
      "entidade": "atendimento",
      "operacao": "update",
      "payload": "{\"id\":\"uuid-atd\",\"status\":\"emDeslocamento\",...}"
    },
    {
      "id": "uuid-3",
      "entidade": "ponto_rastreamento",
      "operacao": "create",
      "payload": "{\"id\":\"uuid-pt\",\"atendimentoId\":\"uuid-atd\",...}"
    }
  ]
}

Response:
{
  "resultados": [
    { "operacaoId": "uuid-da-operacao", "sucesso": true, "erro": null },
    { "operacaoId": "uuid-2", "sucesso": true, "erro": null },
    { "operacaoId": "uuid-3", "sucesso": true, "erro": null }
  ],
  "processadoEm": "2026-03-11T10:00:00Z"
}
```

#### GET `/api/sync/pull?desde={timestamp}` — App puxa atualizações

```
Response:
{
  "clientes": [ ... todos com AtualizadoEm > desde ],
  "atendimentos": [ ... ],
  "bases": [ ... ],
  "usuarios": [ ... ],
  "sincronizadoEm": "2026-03-11T10:00:00Z"
}
```

### 10.3 Regras de Conflito (RN-036)

| Cenário                                                          | Resolução                                    |
| ---------------------------------------------------------------- | -------------------------------------------- |
| App envia `create` mas ID já existe                              | Ignora (idempotente) — retorna sucesso       |
| App envia `update` com `AtualizadoEm` mais antigo que o servidor | Ignora — versão do servidor prevalece        |
| App envia `update` com `AtualizadoEm` mais recente               | Aplica update                                |
| Dois devices editam o mesmo registro                             | Último a sincronizar vence (last-write-wins) |

### 10.4 Handler de Sync no Servidor

```csharp
public class ProcessarSyncBatchCommandHandler
    : IRequestHandler<ProcessarSyncBatchCommand, SyncPushResponse>
{
    private readonly IUnitOfWork _uow;
    private readonly IMediator _mediator;

    public async Task<SyncPushResponse> Handle(
        ProcessarSyncBatchCommand request, CancellationToken ct)
    {
        var resultados = new List<SyncResultDto>();

        foreach (var op in request.Operacoes) // Processar em ordem cronológica
        {
            try
            {
                switch (op.Entidade)
                {
                    case "cliente":
                        await ProcessarCliente(op);
                        break;
                    case "atendimento":
                        await ProcessarAtendimento(op);
                        break;
                    case "ponto_rastreamento":
                        await ProcessarPontoRastreamento(op);
                        break;
                    case "base":
                        await ProcessarBase(op);
                        break;
                }
                resultados.Add(new(op.Id, true, null));
            }
            catch (Exception ex)
            {
                resultados.Add(new(op.Id, false, ex.Message));
            }
        }

        await _uow.SaveChangesAsync(ct);

        return new SyncPushResponse(resultados, DateTime.UtcNow);
    }

    private async Task ProcessarCliente(SyncOperationDto op)
    {
        var dto = JsonSerializer.Deserialize<ClienteDto>(op.Payload);
        var existente = await _uow.Clientes.GetByIdAsync(dto.Id);

        if (op.Operacao == "create")
        {
            if (existente != null) return; // Idempotente
            var entity = MapToEntity(dto);
            await _uow.Clientes.AddAsync(entity);
        }
        else if (op.Operacao == "update")
        {
            if (existente == null) return;
            if (existente.AtualizadoEm >= dto.AtualizadoEm) return; // Last-write-wins
            UpdateEntity(existente, dto);
        }
    }
    // ... similar para outras entidades
}
```

---

## 11. Autenticação e Autorização

### 11.1 JWT Configuration

```csharp
// appsettings.json
{
  "Jwt": {
    "Secret": "chave-secreta-256-bits-minimo",
    "Issuer": "GuinchoApp",
    "Audience": "GuinchoApp.Mobile",
    "ExpirationHours": 720    // 30 dias (offline-first precisa de token longo)
  }
}
```

### 11.2 JwtService

```csharp
public interface IJwtService
{
    string GenerateToken(Usuario usuario);
    ClaimsPrincipal? ValidateToken(string token);
}
```

### 11.3 Auth Flow

```
1. POST /api/auth/login { email, senha }
2. Server: BCrypt.Verify(senha, hash)
3. Server: Gera JWT com claims: sub=id, email, role, exp=30d
4. App: Salva token no FlutterSecureStorage
5. App: Injeta "Authorization: Bearer {token}" em toda request
6. Server: Middleware valida JWT em cada endpoint [Authorize]
```

### 11.4 Roles e Policies

```csharp
// Program.cs
builder.Services.AddAuthorization(options =>
{
    options.AddPolicy("AdminOnly", policy =>
        policy.RequireRole("Administrador"));
    options.AddPolicy("OperadorOuAdmin", policy =>
        policy.RequireRole("Operador", "Administrador"));
});

// Controllers
[Authorize]                           // Todos os endpoints exigem token
[Authorize(Policy = "AdminOnly")]     // Apenas para: POST/PUT /bases
```

| Recurso            | Operador | Administrador |
| ------------------ | -------- | ------------- |
| Clientes CRUD      | ✅       | ✅            |
| Atendimentos CRUD  | ✅       | ✅            |
| Rastreamento       | ✅       | ✅            |
| Dashboard          | ✅       | ✅            |
| Bases CRUD         | ❌       | ✅            |
| Gestão de Usuários | ❌       | ✅            |

---

## 12. Regras de Negócio (RN)

Estas são as 41 regras extraídas do app. Todas devem ser **validadas também no servidor**:

### Gestão de Clientes

| RN     | Regra                                           | Validação Server                        |
| ------ | ----------------------------------------------- | --------------------------------------- |
| RN-001 | Todo atendimento vinculado a cliente            | FK constraint + validator               |
| RN-002 | Buscar cliente por nome/telefone                | Query LIKE                              |
| RN-003 | Criar cliente localmente (nome, telefone, doc?) | Validator: nome e telefone obrigatórios |
| RN-004 | Endereço padrão do cliente                      | Campo opcional                          |
| RN-005 | Sincronizar clientes com backend                | Endpoint sync/push                      |

### Atendimento

| RN      | Regra                                                       | Validação Server                           |
| ------- | ----------------------------------------------------------- | ------------------------------------------ |
| RN-006  | Iniciar atendimento offline                                 | IDs UUID do app                            |
| RN-007  | Exige 4 pontos: saída, coleta, entrega, retorno             | Validator: todos obrigatórios com lat/lng  |
| RN-008  | Ponto de saída: GPS, base ou manual                         | Apenas validar que não é vazio             |
| RN-009  | Coleta/Entrega via autocomplete ou mapa                     | Apenas validar que não é vazio             |
| RN-009B | Retorno pré-preenchido com ponto de saída                   | Lógica de UI, server apenas persiste       |
| RN-010  | Distância = saída→coleta + coleta→entrega + entrega→retorno | Recalcular via Haversine no server         |
| RN-011  | Valor estimado = distância × valor_por_km                   | Recalcular no server                       |
| RN-011B | Retorno SEMPRE cobrado                                      | Incluído no cálculo                        |
| RN-012  | Modo: Fixo OU Por KM                                        | Enum validation                            |
| RN-013  | Modo padrão configurável                                    | Preferência do usuário                     |
| RN-014  | Pode sobrescrever valor antes de concluir                   | Permitido se Status != Concluido/Cancelado |
| RN-015  | Valor por km configurável                                   | Campo no Usuário                           |

### Status e Ciclo de Vida

| RN      | Regra                                       | Validação Server                                |
| ------- | ------------------------------------------- | ----------------------------------------------- |
| RN-016  | Rascunho totalmente editável                | `AtualizarAtendimento` só se status == Rascunho |
| RN-017  | GPS inicia em EmDeslocamento                | Lógica do app                                   |
| RN-018  | Avanço manual pelo operador                 | Validar transição permitida                     |
| RN-019  | GPS ativo durante 4 etapas                  | Lógica do app                                   |
| RN-020  | Conclusão porKm: valor = km_real × valor_km | Recalcular no server                            |
| RN-021  | Cancelável se não Concluido                 | Validar status != Concluido                     |
| RN-022  | Concluído/Cancelado = somente leitura       | Rejeitar updates em status final                |
| RN-022B | Concluído apenas de Retornando              | Validar transição                               |

### Rastreamento GPS

| RN     | Regra                                                     | Validação Server                      |
| ------ | --------------------------------------------------------- | ------------------------------------- |
| RN-023 | Auto-inicia em EmDeslocamento                             | Lógica do app                         |
| RN-024 | Auto-para em Concluído/Cancelado                          | Lógica do app                         |
| RN-025 | Coleta a cada 30s ou 100m                                 | Lógica do app, server apenas armazena |
| RN-026 | Cada ponto: lat, lng, accuracy, timestamp, atendimentoId  | Validator: todos obrigatórios         |
| RN-027 | Salvo localmente, sync em background                      | Endpoint batch POST                   |
| RN-028 | Distância real = soma Haversine entre pontos consecutivos | Calcular no server ao concluir        |

### Bases

| RN     | Regra                           | Validação Server               |
| ------ | ------------------------------- | ------------------------------ |
| RN-029 | Múltiplas bases permitidas      | Sem restrição                  |
| RN-030 | Uma base principal por vez      | Transação: reset all + set one |
| RN-031 | Admin cadastra, sync para todos | Policy: AdminOnly              |

### Sincronização

| RN     | Regra                                     | Validação Server          |
| ------ | ----------------------------------------- | ------------------------- |
| RN-032 | Monitoramento contínuo de conexão         | Lógica do app             |
| RN-033 | Escrita local primeiro, fila sync         | Lógica do app             |
| RN-034 | Fila processada cronologicamente          | Endpoint aceita batch     |
| RN-035 | Retry com backoff exponencial             | Lógica do app             |
| RN-036 | Conflitos: last-write-wins (AtualizadoEm) | **Implementar no server** |
| RN-037 | Indicador visual de sync                  | Lógica do app             |

### Dashboard

| RN      | Regra                                   | Validação Server           |
| ------- | --------------------------------------- | -------------------------- |
| RN-038  | Métricas: km, faturamento, contagem     | Queries agregadas          |
| RN-038B | Distinguir km operacional de km cobrado | Campos separados           |
| RN-039  | Visualizar percurso passado             | GET pontos por atendimento |
| RN-040  | Filtros: período, cliente               | Query parameters           |

---

## 13. Validações (FluentValidation)

### 13.1 Pipeline com MediatR

```csharp
// ValidationBehavior.cs — roda antes de cada Handler
public class ValidationBehavior<TRequest, TResponse>
    : IPipelineBehavior<TRequest, TResponse>
{
    private readonly IEnumerable<IValidator<TRequest>> _validators;

    public async Task<TResponse> Handle(TRequest request,
        RequestHandlerDelegate<TResponse> next, CancellationToken ct)
    {
        var failures = _validators
            .Select(v => v.Validate(request))
            .SelectMany(r => r.Errors)
            .Where(f => f != null)
            .ToList();

        if (failures.Any())
            throw new ValidationException(failures);

        return await next();
    }
}
```

### 13.2 Validators por Command

```csharp
// CriarClienteValidator.cs
public class CriarClienteValidator : AbstractValidator<CriarClienteCommand>
{
    public CriarClienteValidator()
    {
        RuleFor(x => x.Id).NotEmpty().Must(BeValidGuid);
        RuleFor(x => x.Nome).NotEmpty().MaximumLength(200);
        RuleFor(x => x.Telefone).NotEmpty().MaximumLength(20);
        RuleFor(x => x.Documento).MaximumLength(20);
    }
}

// CriarAtendimentoValidator.cs
public class CriarAtendimentoValidator : AbstractValidator<CriarAtendimentoCommand>
{
    public CriarAtendimentoValidator()
    {
        RuleFor(x => x.Id).NotEmpty();
        RuleFor(x => x.ClienteId).NotEmpty();
        RuleFor(x => x.UsuarioId).NotEmpty();
        RuleFor(x => x.PontoDeSaida).NotNull().SetValidator(new LocalGeoValidator());
        RuleFor(x => x.LocalDeColeta).NotNull().SetValidator(new LocalGeoValidator());
        RuleFor(x => x.LocalDeEntrega).NotNull().SetValidator(new LocalGeoValidator());
        RuleFor(x => x.LocalDeRetorno).NotNull().SetValidator(new LocalGeoValidator());
        RuleFor(x => x.ValorPorKm).GreaterThan(0);
        RuleFor(x => x.DistanciaEstimadaKm).GreaterThan(0);
        RuleFor(x => x.TipoValor).Must(v => v == "fixo" || v == "porKm");
    }
}

// LocalGeoValidator.cs
public class LocalGeoValidator : AbstractValidator<LocalGeoDto>
{
    public LocalGeoValidator()
    {
        RuleFor(x => x.EnderecoTexto).NotEmpty().MaximumLength(500);
        RuleFor(x => x.Latitude).InclusiveBetween(-90, 90);
        RuleFor(x => x.Longitude).InclusiveBetween(-180, 180);
    }
}

// AtualizarStatusValidator.cs
public class AtualizarStatusValidator : AbstractValidator<AtualizarStatusCommand>
{
    public AtualizarStatusValidator()
    {
        RuleFor(x => x.AtendimentoId).NotEmpty();
        RuleFor(x => x.NovoStatus).NotEmpty()
            .Must(BeValidStatus).WithMessage("Status inválido");
    }
}
```

---

## 14. Migrations EF Core

### 14.1 Initial Migration

```bash
dotnet ef migrations add InitialCreate -p GuinchoApp.Infrastructure -s GuinchoApp.API
dotnet ef database update -s GuinchoApp.API
```

### 14.2 Seed Data

```csharp
// Seed de usuário admin padrão
public static class SeedData
{
    public static async Task Initialize(IServiceProvider services)
    {
        var uow = services.GetRequiredService<IUnitOfWork>();

        if (!await uow.Usuarios.ExistsAsync("admin-default-id"))
        {
            await uow.Usuarios.AddAsync(new Usuario
            {
                Id = "admin-default-id",
                Nome = "Administrador",
                Email = "admin@guinchoapp.com.br",
                Telefone = "0000000000",
                SenhaHash = BCrypt.Net.BCrypt.HashPassword("admin123"),
                Role = UsuarioRole.Administrador,
                ValorPorKmDefault = 5.0
            });
            await uow.SaveChangesAsync();
        }
    }
}
```

---

## 15. Testes

### 15.1 Estrutura de Testes

```
GuinchoApp.Tests/
├── Application/
│   ├── Auth/
│   │   ├── LoginCommandHandlerTests.cs
│   │   └── LoginCommandValidatorTests.cs
│   ├── Clientes/
│   │   ├── CriarClienteCommandHandlerTests.cs
│   │   └── CriarClienteValidatorTests.cs
│   ├── Atendimentos/
│   │   ├── CriarAtendimentoCommandHandlerTests.cs
│   │   ├── AtualizarStatusCommandHandlerTests.cs    // Testar TODAS as transições
│   │   └── AtualizarStatusValidatorTests.cs
│   ├── Sync/
│   │   └── ProcessarSyncBatchTests.cs               // Idempotência + conflitos
│   └── Dashboard/
│       └── ObterResumoPeriodoQueryTests.cs
├── Domain/
│   └── AtendimentoStatusTransitionTests.cs          // Matriz de transição
└── Infrastructure/
    ├── RepositoryTests.cs                           // InMemoryDatabase
    └── JwtServiceTests.cs
```

### 15.2 Cenários Críticos para Testar

| Cenário                                      | Teste                                 |
| -------------------------------------------- | ------------------------------------- |
| Sync push com ID duplicado                   | Deve retornar sucesso sem duplicar    |
| Sync push com AtualizadoEm antigo            | Deve ignorar update                   |
| Transição inválida de status                 | Deve retornar erro 400                |
| Concluir atendimento porKm sem DistanciaReal | Deve exigir DistanciaRealKm           |
| DefinirPrincipal                             | Resetar todas + setar uma (transação) |
| Batch de 1000+ pontos GPS                    | Performance aceitável                 |
| Login com credenciais inválidas              | 401                                   |
| Acesso a /bases sem role Admin               | 403                                   |

---

## 16. Deploy e Configuração

### 16.1 Pacotes NuGet Necessários

```xml
<!-- GuinchoApp.API -->
<PackageReference Include="MediatR" Version="12.*" />
<PackageReference Include="FluentValidation.DependencyInjectionExtensions" Version="11.*" />
<PackageReference Include="Microsoft.AspNetCore.Authentication.JwtBearer" Version="8.*" />
<PackageReference Include="BCrypt.Net-Next" Version="4.*" />
<PackageReference Include="Swashbuckle.AspNetCore" Version="6.*" />

<!-- GuinchoApp.Infrastructure -->
<PackageReference Include="Microsoft.EntityFrameworkCore" Version="8.*" />
<PackageReference Include="Microsoft.EntityFrameworkCore.SqlServer" Version="8.*" />
<!-- OU para PostgreSQL: -->
<PackageReference Include="Npgsql.EntityFrameworkCore.PostgreSQL" Version="8.*" />

<!-- GuinchoApp.Application -->
<PackageReference Include="AutoMapper.Extensions.Microsoft.DependencyInjection" Version="12.*" />
<PackageReference Include="FluentValidation" Version="11.*" />

<!-- GuinchoApp.Tests -->
<PackageReference Include="xunit" Version="2.*" />
<PackageReference Include="Moq" Version="4.*" />
<PackageReference Include="Microsoft.EntityFrameworkCore.InMemory" Version="8.*" />
```

### 16.2 Program.cs (Resumo)

```csharp
var builder = WebApplication.CreateBuilder(args);

// EF Core
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Unit of Work + Repositories
builder.Services.AddScoped<IUnitOfWork, UnitOfWork>();

// MediatR + Validators
builder.Services.AddMediatR(cfg =>
    cfg.RegisterServicesFromAssembly(typeof(LoginCommand).Assembly));
builder.Services.AddValidatorsFromAssembly(typeof(LoginCommand).Assembly);
builder.Services.AddTransient(typeof(IPipelineBehavior<,>), typeof(ValidationBehavior<,>));

// JWT Auth
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options => { /* configuração JWT */ });
builder.Services.AddAuthorization();
builder.Services.AddScoped<IJwtService, JwtService>();

// AutoMapper
builder.Services.AddAutoMapper(typeof(MappingProfile).Assembly);

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Seed
using (var scope = app.Services.CreateScope())
    await SeedData.Initialize(scope.ServiceProvider);

app.UseSwagger();
app.UseSwaggerUI();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();
app.Run();
```

### 16.3 Connection Strings

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=GuinchoAppDb;Trusted_Connection=true;TrustServerCertificate=true;"
  }
}
```

### 16.4 URL do App Flutter por Flavor

| Flavor  | URL Base                                                            |
| ------- | ------------------------------------------------------------------- |
| dev     | `http://10.0.2.2:5000` (emulador Android) / `http://localhost:5000` |
| staging | `https://staging-api.guinchoapp.com.br`                             |
| prod    | `https://api.guinchoapp.com.br`                                     |

> `10.0.2.2` é o alias do emulador Android para `localhost` da máquina host.

---

## Checklist de Implementação

### Fase 1 — Foundation

- [ ] Criar solution com 4 projetos (API, Application, Domain, Infrastructure)
- [ ] Instalar pacotes NuGet
- [ ] Criar entidades (Domain)
- [ ] Configurar EF Core + Migrations + Seed
- [ ] Implementar GenericRepository + UnitOfWork
- [ ] Configurar JWT + AuthController

### Fase 2 — CRUD

- [ ] Commands + Handlers para Cliente
- [ ] Commands + Handlers para Base
- [ ] Commands + Handlers para Atendimento (com validação de transição de status)
- [ ] Commands + Handlers para Rastreamento (batch)
- [ ] Queries + Handlers para todas as entidades
- [ ] Validators (FluentValidation)
- [ ] Controllers REST

### Fase 3 — Sync

- [ ] Endpoint POST `/api/sync/push` com idempotência
- [ ] Endpoint GET `/api/sync/pull` com filtro por timestamp
- [ ] Lógica de conflict resolution (last-write-wins)
- [ ] Testes de cenários de sync

### Fase 4 — Dashboard

- [ ] Queries agregadas (Resumo, Ranking, Etapas, Diário)
- [ ] Controller com filtros de período

### Fase 5 — QA

- [ ] Testes unitários dos Handlers
- [ ] Testes de integração dos Controllers
- [ ] Testes de validação (boundary values)
- [ ] Swagger documentation
- [ ] Testar sync completo com app Flutter

---

> **Última atualização:** 11/03/2026  
> **Gerado automaticamente** a partir do mapeamento do app Flutter (Sprint 0-8 concluídas, 345 testes)
