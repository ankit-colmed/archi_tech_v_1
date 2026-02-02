# Doctor App – Architecture & Design Documentation

## 1. Introduction

This document describes the **complete architecture** of the `doctor_app` system. The goal of this architecture is to support:

* Multiple **standalone Flutter applications**
* One or more **composite (base) applications** that can reuse standalone apps
* A **shared codebase** for common logic and UI
* Scalability for future apps
* Clean separation of concerns
* Testability, maintainability, and long-term evolution

This architecture is designed for **medium to large-scale Flutter systems**, especially suitable for healthcare and enterprise-grade applications.

---

## 2. High-Level Architectural Principles

The architecture is based on the following principles:

1. **Monorepo structure** – all apps live in a single repository
2. **Standalone-first design** – every app can run independently
3. **Composable applications** – some apps can embed others
4. **Clean Architecture** – strict separation of UI, business logic, and data
5. **Feature-first organization** – features are isolated and scalable
6. **Package-based reuse** – shared logic is distributed as packages
7. **Unidirectional data flow** – predictable and debuggable behavior

---

## 3. Root-Level Repository Structure

```
doctor_app/
│
├── apps/
│   ├── SA_APP_1/
│   ├── SA_APP_2/
│   ├── SA_APP_3/
│   ├── SA_APP_4/
│   ├── SA_APP_5/
│   ├── BA_APP_1/
│   └── BA_APP_2/
│
├── shared/
│   ├── core/
│   ├── domain/
│   ├── data/
│   └── ui/
│
├── melos.yaml
└── README.md
```

### Repository Structure Diagram

```mermaid
graph TB
    subgraph "doctor_app Repository"
        ROOT[doctor_app/]
        
        subgraph "apps/"
            SA1[SA_APP_1<br/>Authentication]
            SA2[SA_APP_2<br/>Patient Management]
            SA3[SA_APP_3<br/>Appointments]
            SA4[SA_APP_4<br/>Reports]
            SA5[SA_APP_5<br/>Settings]
            BA1[BA_APP_1<br/>Doctor Dashboard]
            BA2[BA_APP_2<br/>Hospital Admin]
        end
        
        subgraph "shared/"
            CORE[core/<br/>Utilities & Infrastructure]
            DOMAIN[domain/<br/>Business Rules]
            DATA[data/<br/>Data Access]
            UI[ui/<br/>Design System]
        end
        
        MELOS[melos.yaml]
        README[README.md]
    end
    
    ROOT --> apps/
    ROOT --> shared/
    ROOT --> MELOS
    ROOT --> README
    
    style SA1 fill:#e1f5ff
    style SA2 fill:#e1f5ff
    style SA3 fill:#e1f5ff
    style SA4 fill:#e1f5ff
    style SA5 fill:#e1f5ff
    style BA1 fill:#ffe1f5
    style BA2 fill:#ffe1f5
    style CORE fill:#fff4e1
    style DOMAIN fill:#fff4e1
    style DATA fill:#fff4e1
    style UI fill:#fff4e1
```

### Why a Monorepo?

* Easier dependency management
* Atomic refactoring across apps
* Shared tooling and CI/CD
* Consistent architecture across all applications

---

## 4. Application Classification

### 4.1 Standalone Applications (SA_APP_n)

**SA apps** are fully independent Flutter applications.

Characteristics:

* Can run on their own
* Have their own `main.dart`
* Can be embedded inside BA apps
* Depend only on `shared/*` packages
* Never depend on BA apps

Examples:

* SA_APP_1 – Authentication
* SA_APP_2 – Patient Management
* SA_APP_3 – Appointments
* SA_APP_4 – Reports
* SA_APP_5 – Settings

---

### 4.2 Base / Composite Applications (BA_APP_n)

**BA apps** are orchestration apps that compose multiple SA apps.

Characteristics:

* Can run independently
* Import SA apps as dependencies
* Combine features into unified flows
* Control navigation and dependency wiring

Examples:

* BA_APP_1 – Doctor Dashboard
* BA_APP_2 – Hospital Admin Console

### Application Dependency Flow

```mermaid
graph TD
    subgraph "Shared Packages"
        CORE[shared/core]
        DOMAIN[shared/domain]
        DATA[shared/data]
        UI[shared/ui]
    end
    
    subgraph "Standalone Apps"
        SA1[SA_APP_1<br/>Authentication]
        SA2[SA_APP_2<br/>Patient Mgmt]
        SA3[SA_APP_3<br/>Appointments]
        SA4[SA_APP_4<br/>Reports]
        SA5[SA_APP_5<br/>Settings]
    end
    
    subgraph "Base Apps"
        BA1[BA_APP_1<br/>Doctor Dashboard]
        BA2[BA_APP_2<br/>Hospital Admin]
    end
    
    SA1 --> CORE
    SA1 --> DOMAIN
    SA1 --> DATA
    SA1 --> UI
    
    SA2 --> CORE
    SA2 --> DOMAIN
    SA2 --> DATA
    SA2 --> UI
    
    SA3 --> CORE
    SA3 --> DOMAIN
    SA3 --> DATA
    SA3 --> UI
    
    SA4 --> CORE
    SA4 --> DOMAIN
    SA4 --> DATA
    SA4 --> UI
    
    SA5 --> CORE
    SA5 --> DOMAIN
    SA5 --> DATA
    SA5 --> UI
    
    BA1 --> SA1
    BA1 --> SA2
    BA1 --> SA3
    BA1 --> SA4
    BA1 --> SA5
    BA1 --> CORE
    BA1 --> DOMAIN
    BA1 --> DATA
    BA1 --> UI
    
    BA2 --> SA1
    BA2 --> SA2
    BA2 --> SA3
    BA2 --> CORE
    BA2 --> DOMAIN
    BA2 --> DATA
    BA2 --> UI
    
    DATA --> DOMAIN
    DATA --> CORE
    UI --> CORE
    
    style SA1 fill:#e1f5ff
    style SA2 fill:#e1f5ff
    style SA3 fill:#e1f5ff
    style SA4 fill:#e1f5ff
    style SA5 fill:#e1f5ff
    style BA1 fill:#ffe1f5
    style BA2 fill:#ffe1f5
    style CORE fill:#fff4e1
    style DOMAIN fill:#fff4e1
    style DATA fill:#fff4e1
    style UI fill:#fff4e1
```

---

## 5. Shared Directory Design

The `shared/` directory contains **reusable packages**. It is not an app.

### Why Shared Is Split Into Packages

Flutter and Dart only support **dependency management at package level**.
Each reusable unit must have its own `pubspec.yaml`.

Benefits:

* Strong dependency boundaries
* Independent testing
* Controlled reuse
* Clean Architecture enforcement

---

## 6. Shared Packages Explained

### 6.1 shared/core

**Purpose:** Cross-cutting utilities and infrastructure

Contents:

* Network helpers
* Error handling
* Logging
* Constants
* Base classes

Rules:

* No Flutter UI
* No app-level dependencies

---

### 6.2 shared/domain

**Purpose:** Central business rules shared across apps

Contents:

* Entities (Doctor, Patient, Session, etc.)
* Repository contracts
* Use cases

Rules:

* Pure Dart
* No Flutter imports
* No data source implementations

Why it exists:

* Prevents duplication of business rules
* Acts as a single source of truth
* Allows consistent behavior across apps

---

### 6.3 shared/data

**Purpose:** Shared data access logic

Contents:

* API clients
* Local storage helpers
* Shared repository implementations

Rules:

* Depends on `shared/domain`
* May use Flutter plugins
* No UI code

---

### 6.4 shared/ui

**Purpose:** Design system and UI infrastructure

Contents:

* Reusable widgets
* Themes
* Responsive layout helpers
* Platform-specific UI abstractions

Rules:

* Flutter-only
* No business logic
* No app-specific navigation

### Shared Packages Internal Dependencies

```mermaid
graph LR
    CORE[shared/core<br/>Infrastructure]
    DOMAIN[shared/domain<br/>Business Rules]
    DATA[shared/data<br/>Data Access]
    UI[shared/ui<br/>Design System]
    
    DATA --> DOMAIN
    DATA --> CORE
    UI --> CORE
    DOMAIN -.->|Pure Dart Only| CORE
    
    style CORE fill:#fff4e1
    style DOMAIN fill:#ffe4e1
    style DATA fill:#e4f1ff
    style UI fill:#e4ffe4
```

---

## 7. Architecture Inside Each App (SA & BA)

Each app follows **Feature-first Clean Architecture**.

```
lib/
├── app/
├── features/
│   └── feature_name/
│        ├── presentation/
│        ├── domain/
│        └── data/
├── di/
└── main.dart
```

### App Internal Structure

```mermaid
graph TB
    subgraph "App Structure"
        MAIN[main.dart]
        
        subgraph "app/"
            ROUTER[router/<br/>Navigation]
            CONFIG[config/<br/>App Config]
        end
        
        subgraph "features/"
            subgraph "feature_name/"
                PRES[presentation/<br/>UI & BLoC]
                DOM[domain/<br/>Use Cases]
                DAT[data/<br/>Repositories]
            end
        end
        
        DI[di/<br/>Dependency Injection]
    end
    
    MAIN --> DI
    MAIN --> ROUTER
    MAIN --> CONFIG
    DI --> PRES
    DI --> DOM
    DI --> DAT
    PRES --> DOM
    DOM --> DAT
    ROUTER --> PRES
    
    style MAIN fill:#ff9999
    style PRES fill:#99ff99
    style DOM fill:#9999ff
    style DAT fill:#ffff99
    style DI fill:#ff99ff
    style ROUTER fill:#99ffff
```

---

## 8. Clean Architecture Layers Explained

### 8.1 Presentation Layer

**Responsibilities:**

* UI widgets
* Responsive layouts
* Platform-specific UI
* Bloc / Cubit state management

Must NOT:

* Call APIs
* Access databases
* Contain business rules

---

### 8.2 Domain Layer

**Responsibilities:**

* Business rules
* Use cases
* Entities

Why this layer exists:

* Protects business logic from UI and data changes
* Centralizes decision-making
* Enables testability

Key rule:

> UI talks only to Domain, never directly to Data

---

### 8.3 Data Layer

**Responsibilities:**

* API calls
* Local storage
* Caching
* Mapping models to entities

Must NOT:

* Contain UI logic
* Decide business rules

### Clean Architecture Flow

```mermaid
graph TB
    subgraph "Presentation Layer"
        UI[Widgets & Pages]
        BLOC[BLoC / Cubit]
        STATE[States & Events]
    end
    
    subgraph "Domain Layer"
        UC[Use Cases]
        ENT[Entities]
        REPO_INT[Repository<br/>Interfaces]
    end
    
    subgraph "Data Layer"
        REPO_IMPL[Repository<br/>Implementations]
        DS[Data Sources]
        API[API / Local DB]
        MODEL[Models]
    end
    
    UI --> BLOC
    BLOC --> STATE
    BLOC --> UC
    UC --> REPO_INT
    UC --> ENT
    REPO_INT -.->|implements| REPO_IMPL
    REPO_IMPL --> DS
    DS --> API
    MODEL -.->|maps to| ENT
    
    style UI fill:#99ff99
    style BLOC fill:#99ff99
    style UC fill:#9999ff
    style ENT fill:#9999ff
    style REPO_IMPL fill:#ffff99
    style DS fill:#ffff99
    style API fill:#ffcccc
```

### Data Flow Diagram

```mermaid
sequenceDiagram
    participant User
    participant UI
    participant BLoC
    participant UseCase
    participant Repository
    participant DataSource
    participant API
    
    User->>UI: Interacts
    UI->>BLoC: Triggers Event
    BLoC->>UseCase: Calls Use Case
    UseCase->>Repository: Requests Data
    Repository->>DataSource: Fetches from Source
    DataSource->>API: API Call
    API-->>DataSource: Response
    DataSource-->>Repository: Model
    Repository-->>UseCase: Entity
    UseCase-->>BLoC: Result
    BLoC->>BLoC: Emits State
    BLoC-->>UI: State Update
    UI-->>User: UI Updates
```

---

## 9. Responsive & Platform-Specific UI

### Where It Lives

* Implemented in `shared/ui`
* Used inside the Presentation layer

### Why Here

* UI concern only
* Reusable across apps
* Keeps domain Flutter-free

Examples:

* ResponsiveBuilder
* PlatformWidget
* Breakpoint definitions

---

## 10. Centralized Navigation (go_router)

### Where Navigation Lives

```
lib/app/router/
├── app_router.dart
├── route_names.dart
└── route_guards.dart
```

### Design Rules

* Features do not own navigation
* Apps compose routes
* SA apps expose routes optionally
* BA apps aggregate routes

### Benefits

* Predictable navigation
* Easy deep linking
* Centralized guards (auth, role-based access)

### Navigation Flow

```mermaid
graph TB
    subgraph "Navigation System"
        MAIN[main.dart]
        
        subgraph "app/router/"
            ROUTER[app_router.dart<br/>Route Configuration]
            NAMES[route_names.dart<br/>Route Constants]
            GUARDS[route_guards.dart<br/>Auth & Permission]
        end
        
        subgraph "Features"
            F1[Feature 1 Routes]
            F2[Feature 2 Routes]
            F3[Feature 3 Routes]
        end
        
        USER[User Navigation]
    end
    
    MAIN --> ROUTER
    ROUTER --> GUARDS
    ROUTER --> NAMES
    ROUTER --> F1
    ROUTER --> F2
    ROUTER --> F3
    USER --> ROUTER
    GUARDS -.->|Validates| USER
    
    style ROUTER fill:#99ccff
    style GUARDS fill:#ffcc99
    style MAIN fill:#ff9999
```

---

## 11. Dependency Injection (DI)

### Why DI Is Required

Given:

* Multiple apps
* Shared logic
* Reusable features
* Future scaling

DI provides:

* Loose coupling
* Replaceable implementations
* Easy testing
* Runtime configuration

---

### Where DI Lives

```
lib/di/
├── injection_container.dart
└── app_modules.dart
```

Each app owns its DI setup.

---

### What Gets Injected

* Blocs / Cubits
* Use cases
* Repositories
* Data sources
* Shared services (network, storage)

---

### Special Role of DI in BA Apps

* BA apps can override SA implementations
* BA apps can compose multiple repositories
* Enables orchestration without modifying SA apps

### Dependency Injection Flow

```mermaid
graph TB
    subgraph "Dependency Injection Container"
        CONTAINER[injection_container.dart]
        
        subgraph "Registration"
            BLOC_REG[BLoCs/Cubits]
            UC_REG[Use Cases]
            REPO_REG[Repositories]
            DS_REG[Data Sources]
            SERVICE_REG[Services]
        end
        
        subgraph "App Modules"
            AUTH_MOD[Auth Module]
            PATIENT_MOD[Patient Module]
            APPT_MOD[Appointment Module]
        end
    end
    
    subgraph "Application"
        MAIN[main.dart]
        UI[UI Widgets]
    end
    
    MAIN --> CONTAINER
    CONTAINER --> BLOC_REG
    CONTAINER --> UC_REG
    CONTAINER --> REPO_REG
    CONTAINER --> DS_REG
    CONTAINER --> SERVICE_REG
    
    BLOC_REG --> UC_REG
    UC_REG --> REPO_REG
    REPO_REG --> DS_REG
    REPO_REG --> SERVICE_REG
    
    AUTH_MOD --> CONTAINER
    PATIENT_MOD --> CONTAINER
    APPT_MOD --> CONTAINER
    
    UI --> BLOC_REG
    
    style CONTAINER fill:#ff99ff
    style MAIN fill:#ff9999
    style UI fill:#99ff99
```

---

## 12. Dependency Rules (Critical)

```
BA_APP → SA_APP → shared
SA_APP → shared
shared → NOTHING
```

Forbidden:

* shared → app
* SA → BA
* Circular dependencies

### Dependency Rules Visualization

```mermaid
graph TD
    BA[Base Apps<br/>BA_APP]
    SA[Standalone Apps<br/>SA_APP]
    SHARED[Shared Packages]
    
    BA -->|✓ Allowed| SA
    BA -->|✓ Allowed| SHARED
    SA -->|✓ Allowed| SHARED
    SA -.->|✗ Forbidden| BA
    SHARED -.->|✗ Forbidden| SA
    SHARED -.->|✗ Forbidden| BA
    
    style BA fill:#ffe1f5
    style SA fill:#e1f5ff
    style SHARED fill:#fff4e1
```

---

## 13. Scaling the System

Adding a new app:

* Create SA_APP_n
* Add dependencies to shared packages
* Optionally compose in BA apps

No refactoring required.

### System Scaling Diagram

```mermaid
graph TB
    subgraph "Current System"
        SA1[SA_APP_1]
        SA2[SA_APP_2]
        SA3[SA_APP_3]
        BA1[BA_APP_1]
        SHARED1[shared packages]
    end
    
    subgraph "Adding New Feature"
        SA_NEW[SA_APP_NEW<br/>New Feature]
        SHARED2[shared packages<br/>unchanged]
    end
    
    subgraph "Future Expansion"
        BA_NEW[BA_APP_NEW<br/>New Composite]
    end
    
    SA_NEW --> SHARED2
    BA_NEW --> SA_NEW
    BA_NEW --> SA1
    BA_NEW --> SA2
    
    style SA_NEW fill:#c1f5c1
    style BA_NEW fill:#f5c1c1
    style SHARED2 fill:#fff4e1
```

---

## 14. Key Benefits of This Architecture

* Standalone execution
* Feature reuse
* Strong boundaries
* Testability
* Offline-first readiness
* Long-term maintainability
* Enterprise-grade scalability

---

## 15. Final Summary

This architecture treats applications as **independent building blocks**, shared logic as **internal SDKs**, and base apps as **composers**.

> UI adapts, Domain decides, Data executes, DI wires, Routes compose.

This design ensures that `doctor_app` can grow in size, complexity, and team count without architectural decay.

### Complete System Overview

```mermaid
graph TB
    subgraph "doctor_app Ecosystem"
        subgraph "Apps Layer"
            SA[Standalone Apps<br/>Independent & Reusable]
            BA[Base Apps<br/>Orchestrators]
        end
        
        subgraph "Shared Layer"
            UI_PKG[shared/ui<br/>Design System]
            DATA_PKG[shared/data<br/>Data Access]
            DOMAIN_PKG[shared/domain<br/>Business Rules]
            CORE_PKG[shared/core<br/>Infrastructure]
        end
        
        subgraph "External"
            API_EXT[External APIs]
            DB_EXT[Databases]
            STORAGE[Local Storage]
        end
    end
    
    BA --> SA
    SA --> UI_PKG
    SA --> DATA_PKG
    SA --> DOMAIN_PKG
    SA --> CORE_PKG
    BA --> UI_PKG
    BA --> DATA_PKG
    BA --> DOMAIN_PKG
    BA --> CORE_PKG
    
    DATA_PKG --> API_EXT
    DATA_PKG --> DB_EXT
    DATA_PKG --> STORAGE
    DATA_PKG --> DOMAIN_PKG
    DATA_PKG --> CORE_PKG
    UI_PKG --> CORE_PKG
    
    style BA fill:#ffe1f5
    style SA fill:#e1f5ff
    style UI_PKG fill:#e4ffe4
    style DATA_PKG fill:#e4f1ff
    style DOMAIN_PKG fill:#ffe4e1
    style CORE_PKG fill:#fff4e1
    style API_EXT fill:#ffcccc
    style DB_EXT fill:#ffcccc
    style STORAGE fill:#ffcccc
```
