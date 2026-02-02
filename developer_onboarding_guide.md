# Doctor App - Developer Onboarding Guide

Welcome to the **doctor_app** project! This guide will help you understand the architecture and start contributing quickly.

---

## 📋 Table of Contents

1. [Quick Start](#quick-start)
2. [Understanding the Architecture](#understanding-the-architecture)
3. [Project Structure](#project-structure)
4. [Development Workflow](#development-workflow)
5. [Common Tasks](#common-tasks)
6. [Best Practices](#best-practices)
7. [FAQs](#faqs)
8. [Resources](#resources)

---

## 🚀 Quick Start

### Prerequisites

Before you begin, ensure you have:

- **Flutter SDK** (latest stable version)
- **Dart SDK** (comes with Flutter)
- **Git**
- **IDE**: VS Code or Android Studio with Flutter plugins
- **Melos**: Install globally with `dart pub global activate melos`

### Initial Setup

```bash
# 1. Clone the repository
git clone <repository-url>
cd doctor_app

# 2. Bootstrap all packages
melos bootstrap

# 3. Run code generation (if needed)
melos run codegen

# 4. Run a standalone app
cd apps/SA_APP_1
flutter run
```

---

## 🏗️ Understanding the Architecture

### The Big Picture

```mermaid
graph TB
    YOU[You as Developer]
    
    subgraph "What You'll Work On"
        FEATURE[Feature Development]
        UI[UI Components]
        LOGIC[Business Logic]
    end
    
    subgraph "Where Your Code Goes"
        SA[Standalone App<br/>SA_APP_n]
        SHARED[Shared Packages]
    end
    
    subgraph "Architecture Layers"
        PRES[Presentation<br/>Widgets & BLoC]
        DOM[Domain<br/>Use Cases]
        DATA[Data<br/>Repositories]
    end
    
    YOU --> FEATURE
    FEATURE --> SA
    FEATURE --> SHARED
    SA --> PRES
    SA --> DOM
    SA --> DATA
    UI --> PRES
    LOGIC --> DOM
    
    style YOU fill:#ff9999
    style SA fill:#e1f5ff
    style SHARED fill:#fff4e1
    style PRES fill:#99ff99
    style DOM fill:#9999ff
    style DATA fill:#ffff99
```

### Three Core Concepts

#### 1. **Monorepo Structure**
All apps and shared code live in one repository. Think of it as a "mini ecosystem."

#### 2. **Standalone vs Base Apps**
- **SA Apps**: Self-contained features (like Lego blocks)
- **BA Apps**: Combine SA apps (like a Lego creation)

#### 3. **Clean Architecture**
Code is organized in three layers:
- **Presentation**: What users see
- **Domain**: Business rules and logic
- **Data**: Where data comes from

---

## 📁 Project Structure

### High-Level Overview

```
doctor_app/
│
├── apps/                    # All applications
│   ├── SA_APP_1/           # Standalone: Authentication
│   ├── SA_APP_2/           # Standalone: Patient Management
│   ├── BA_APP_1/           # Base: Doctor Dashboard
│   └── ...
│
├── shared/                  # Reusable code
│   ├── core/               # Utilities & infrastructure
│   ├── domain/             # Business entities & rules
│   ├── data/               # API clients & repositories
│   └── ui/                 # Design system & widgets
│
├── melos.yaml              # Monorepo configuration
└── README.md
```

### Inside Each App

```
SA_APP_n/
├── lib/
│   ├── main.dart                    # Entry point
│   ├── app/                         # App-level config
│   │   ├── router/                  # Navigation
│   │   └── config/                  # Configuration
│   ├── features/                    # Feature modules
│   │   └── feature_name/
│   │       ├── presentation/        # UI + BLoC
│   │       ├── domain/              # Use cases
│   │       └── data/                # Repositories
│   └── di/                          # Dependency injection
├── test/                            # Tests
└── pubspec.yaml                     # Dependencies
```

---

## 🔄 Development Workflow

### Your Daily Workflow

```mermaid
graph LR
    START[Start Work]
    BRANCH[Create Branch]
    CODE[Write Code]
    TEST[Test Locally]
    COMMIT[Commit]
    PR[Create PR]
    REVIEW[Code Review]
    MERGE[Merge]
    
    START --> BRANCH
    BRANCH --> CODE
    CODE --> TEST
    TEST --> COMMIT
    COMMIT --> PR
    PR --> REVIEW
    REVIEW -->|Changes Needed| CODE
    REVIEW -->|Approved| MERGE
    
    style START fill:#99ff99
    style TEST fill:#ffff99
    style REVIEW fill:#ff9999
    style MERGE fill:#99ff99
```

### Step-by-Step Process

#### 1. **Pick a Task**
- Check your project management tool (Jira, Trello, etc.)
- Understand the requirements
- Ask questions if unclear

#### 2. **Create a Feature Branch**
```bash
git checkout -b feature/your-feature-name
```

#### 3. **Determine Where to Work**

**Is it a new feature?**
- Create it in an SA app if it's standalone
- Add it to a BA app if it orchestrates multiple features

**Is it UI that will be reused?**
- Add it to `shared/ui`

**Is it business logic used everywhere?**
- Add entities to `shared/domain`
- Add repository interfaces to `shared/domain`

**Is it data access logic?**
- Add it to `shared/data`

#### 4. **Follow Clean Architecture**

```mermaid
graph TB
    START[New Feature Request]
    
    Q1{Reusable<br/>across apps?}
    Q2{What type?}
    
    SA[Add to SA_APP]
    UI_PKG[Add to shared/ui]
    DOMAIN_PKG[Add to shared/domain]
    DATA_PKG[Add to shared/data]
    
    LAYERS[Follow 3 Layers:<br/>Presentation<br/>Domain<br/>Data]
    
    START --> Q1
    Q1 -->|No| SA
    Q1 -->|Yes| Q2
    Q2 -->|UI Component| UI_PKG
    Q2 -->|Business Logic| DOMAIN_PKG
    Q2 -->|Data Access| DATA_PKG
    SA --> LAYERS
    
    style START fill:#99ff99
    style SA fill:#e1f5ff
    style UI_PKG fill:#e4ffe4
    style DOMAIN_PKG fill:#ffe4e1
    style DATA_PKG fill:#e4f1ff
```

#### 5. **Write Tests**
```bash
# Unit tests for domain layer
flutter test test/features/your_feature/domain

# Widget tests for presentation
flutter test test/features/your_feature/presentation

# Integration tests
flutter test integration_test
```

#### 6. **Run and Debug**
```bash
# Run specific app
cd apps/SA_APP_1
flutter run

# Hot reload works!
# Press 'r' to hot reload
# Press 'R' to hot restart
```

---

## 🛠️ Common Tasks

### Task 1: Creating a New Feature

Let's create a "Prescription" feature as an example.

#### Step 1: Set Up the Feature Structure
```bash
cd apps/SA_APP_2  # Patient Management app
mkdir -p lib/features/prescription/{presentation,domain,data}
```

#### Step 2: Create Domain Layer

**File: `lib/features/prescription/domain/entities/prescription.dart`**
```dart
class Prescription {
  final String id;
  final String patientId;
  final String doctorId;
  final List<String> medications;
  final DateTime createdAt;

  Prescription({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.medications,
    required this.createdAt,
  });
}
```

**File: `lib/features/prescription/domain/repositories/prescription_repository.dart`**
```dart
abstract class PrescriptionRepository {
  Future<List<Prescription>> getPrescriptions(String patientId);
  Future<void> createPrescription(Prescription prescription);
}
```

**File: `lib/features/prescription/domain/usecases/get_prescriptions.dart`**
```dart
class GetPrescriptions {
  final PrescriptionRepository repository;

  GetPrescriptions(this.repository);

  Future<List<Prescription>> call(String patientId) {
    return repository.getPrescriptions(patientId);
  }
}
```

#### Step 3: Create Data Layer

**File: `lib/features/prescription/data/repositories/prescription_repository_impl.dart`**
```dart
class PrescriptionRepositoryImpl implements PrescriptionRepository {
  final PrescriptionDataSource dataSource;

  PrescriptionRepositoryImpl(this.dataSource);

  @override
  Future<List<Prescription>> getPrescriptions(String patientId) async {
    final models = await dataSource.fetchPrescriptions(patientId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> createPrescription(Prescription prescription) async {
    await dataSource.savePrescription(prescription);
  }
}
```

#### Step 4: Create Presentation Layer

**File: `lib/features/prescription/presentation/bloc/prescription_bloc.dart`**
```dart
class PrescriptionBloc extends Bloc<PrescriptionEvent, PrescriptionState> {
  final GetPrescriptions getPrescriptions;

  PrescriptionBloc({required this.getPrescriptions}) 
    : super(PrescriptionInitial()) {
    on<LoadPrescriptions>(_onLoadPrescriptions);
  }

  Future<void> _onLoadPrescriptions(
    LoadPrescriptions event,
    Emitter<PrescriptionState> emit,
  ) async {
    emit(PrescriptionLoading());
    try {
      final prescriptions = await getPrescriptions(event.patientId);
      emit(PrescriptionLoaded(prescriptions));
    } catch (e) {
      emit(PrescriptionError(e.toString()));
    }
  }
}
```

**File: `lib/features/prescription/presentation/pages/prescription_list_page.dart`**
```dart
class PrescriptionListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrescriptionBloc, PrescriptionState>(
      builder: (context, state) {
        if (state is PrescriptionLoading) {
          return CircularProgressIndicator();
        }
        if (state is PrescriptionLoaded) {
          return ListView.builder(
            itemCount: state.prescriptions.length,
            itemBuilder: (context, index) {
              final prescription = state.prescriptions[index];
              return PrescriptionCard(prescription: prescription);
            },
          );
        }
        if (state is PrescriptionError) {
          return Text('Error: ${state.message}');
        }
        return Container();
      },
    );
  }
}
```

#### Step 5: Register in DI Container

**File: `lib/di/injection_container.dart`**
```dart
// Add to your DI setup
sl.registerFactory(() => PrescriptionBloc(
  getPrescriptions: sl(),
));

sl.registerLazySingleton(() => GetPrescriptions(sl()));

sl.registerLazySingleton<PrescriptionRepository>(
  () => PrescriptionRepositoryImpl(sl()),
);

sl.registerLazySingleton<PrescriptionDataSource>(
  () => PrescriptionDataSourceImpl(sl()),
);
```

---

### Task 2: Adding a Reusable Widget

If your widget will be used across multiple apps, add it to `shared/ui`.

**File: `shared/ui/lib/widgets/custom_button.dart`**
```dart
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  const CustomButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading 
        ? CircularProgressIndicator() 
        : Text(label),
    );
  }
}
```

Export it in `shared/ui/lib/ui.dart`:
```dart
export 'widgets/custom_button.dart';
```

---

### Task 3: Working with Melos

**Bootstrap all packages:**
```bash
melos bootstrap
```

**Run tests across all packages:**
```bash
melos run test
```

**Clean all packages:**
```bash
melos clean
```

**Run code generation:**
```bash
melos run codegen
```

**Version and publish packages:**
```bash
melos version
melos publish
```

---

## ✅ Best Practices

### 1. **Dependency Rules (CRITICAL)**

```mermaid
graph TD
    BA[Base App]
    SA[Standalone App]
    SHARED[Shared Packages]
    
    BA -->|✓ Can depend on| SA
    BA -->|✓ Can depend on| SHARED
    SA -->|✓ Can depend on| SHARED
    SA -.->|✗ NEVER| BA
    SHARED -.->|✗ NEVER| SA
    SHARED -.->|✗ NEVER| BA
    
    style BA fill:#ffe1f5
    style SA fill:#e1f5ff
    style SHARED fill:#fff4e1
```

**Rules:**
- ✅ SA apps can use shared packages
- ✅ BA apps can use SA apps and shared packages
- ❌ Shared packages NEVER import apps
- ❌ SA apps NEVER import BA apps

### 2. **Clean Architecture Flow**

**Always follow this flow:**
```
User Action → Widget → BLoC → Use Case → Repository → Data Source → API
```

**Never do this:**
```
Widget → Repository ❌
BLoC → Data Source ❌
Widget → API ❌
```

### 3. **Code Organization Checklist**

- [ ] Is my feature in the right app? (SA vs BA)
- [ ] Are my layers properly separated? (Presentation, Domain, Data)
- [ ] Is my reusable code in `shared/`?
- [ ] Did I register dependencies in DI?
- [ ] Did I write tests?
- [ ] Did I update documentation?

### 4. **Naming Conventions**

**Files:**
- snake_case: `prescription_list_page.dart`
- Clear, descriptive names

**Classes:**
- PascalCase: `PrescriptionBloc`
- Suffixes: `Page`, `Widget`, `Bloc`, `Cubit`, `Repository`, `UseCase`

**Variables:**
- camelCase: `patientId`, `prescriptionList`

### 5. **Testing Strategy**

```mermaid
graph TB
    UNIT[Unit Tests<br/>Domain Layer]
    WIDGET[Widget Tests<br/>Presentation Layer]
    INTEGRATION[Integration Tests<br/>End-to-End]
    
    UNIT -->|Test| UC[Use Cases]
    UNIT -->|Test| REPO[Repositories]
    WIDGET -->|Test| BLOC[BLoCs]
    WIDGET -->|Test| UI[Widgets]
    INTEGRATION -->|Test| FLOW[User Flows]
    
    style UNIT fill:#99ff99
    style WIDGET fill:#ffff99
    style INTEGRATION fill:#ff9999
```

**Test Coverage Goals:**
- Domain Layer: 90%+
- Presentation Layer: 70%+
- Data Layer: 80%+

---

## ❓ FAQs

### Q1: Where should I put my new feature?

**Decision Tree:**

```mermaid
graph TB
    START[New Feature]
    Q1{Used by multiple<br/>BA apps?}
    Q2{Standalone<br/>functionality?}
    
    SA[Create in new<br/>SA_APP]
    EXISTING_SA[Add to existing<br/>SA_APP]
    BA[Add to BA_APP]
    
    START --> Q1
    Q1 -->|Yes| Q2
    Q1 -->|No| BA
    Q2 -->|Yes| SA
    Q2 -->|No| EXISTING_SA
```

### Q2: Can I use a package from pub.dev?

**Yes!** But follow these rules:
1. Check with team lead first
2. Add it to the appropriate `pubspec.yaml`
3. Document why you need it
4. Consider adding it to `shared/core` if used everywhere

### Q3: How do I debug a specific app?

```bash
cd apps/SA_APP_1
flutter run -d <device>

# For web
flutter run -d chrome

# For desktop
flutter run -d macos  # or windows, linux
```

### Q4: My app is slow. What should I check?

1. **BLoC emitting too often?** Use `debounceTime`
2. **Building too many widgets?** Use `const` constructors
3. **Loading too much data?** Implement pagination
4. **Not disposing resources?** Check `dispose()` methods

### Q5: How do I handle errors?

**In Use Cases:**
```dart
return repository.getData().then(
  (data) => Right(data),
  onError: (error) => Left(ServerFailure()),
);
```

**In BLoCs:**
```dart
try {
  final result = await useCase();
  emit(SuccessState(result));
} catch (e) {
  emit(ErrorState(e.toString()));
}
```

**In Widgets:**
```dart
BlocBuilder<MyBloc, MyState>(
  builder: (context, state) {
    if (state is ErrorState) {
      return ErrorWidget(state.message);
    }
    // ... other states
  },
)
```

---

## 📚 Resources

### Documentation
- [Flutter Official Docs](https://flutter.dev/docs)
- [BLoC Pattern Documentation](https://bloclibrary.dev)
- [Clean Architecture Principles](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

### Project-Specific
- **Architecture Doc**: See `doctor_app_architecture_with_diagrams.md`
- **API Documentation**: [Link to API docs]
- **Design System**: Check `shared/ui/README.md`

### Tools
- **Melos**: [Documentation](https://melos.invertase.dev/)
- **go_router**: [Documentation](https://pub.dev/packages/go_router)
- **get_it**: [Documentation](https://pub.dev/packages/get_it)

### Getting Help
- **Slack/Teams**: #doctor-app-dev channel
- **Code Reviews**: Tag @senior-dev for architecture questions
- **Weekly Sync**: Thursdays at 10 AM

---

## 🎯 Your First Week

### Day 1: Setup & Exploration
- [ ] Complete environment setup
- [ ] Run all SA apps successfully
- [ ] Explore the codebase structure
- [ ] Read architecture documentation

### Day 2: Understanding
- [ ] Pick a simple feature and trace its flow
- [ ] Understand how navigation works
- [ ] Review dependency injection setup
- [ ] Study one complete feature

### Day 3: Small Contribution
- [ ] Fix a small bug or UI issue
- [ ] Write tests for your fix
- [ ] Create your first PR
- [ ] Get familiar with code review process

### Day 4-5: Feature Work
- [ ] Pick a small feature task
- [ ] Implement following clean architecture
- [ ] Write comprehensive tests
- [ ] Document your changes

---

## 🚦 Quick Reference Commands

```bash
# Bootstrap project
melos bootstrap

# Run specific app
cd apps/SA_APP_1 && flutter run

# Run all tests
melos run test

# Generate code
melos run codegen

# Clean everything
melos clean && flutter clean

# Check for issues
flutter analyze

# Format code
dart format .

# Get dependencies
flutter pub get
```

---

## 🎉 Welcome Aboard!

You're now ready to contribute to the doctor_app project. Remember:

1. **Ask questions** – No question is too small
2. **Follow the architecture** – It's there to help you
3. **Write tests** – Future you will thank present you
4. **Collaborate** – Review others' code and ask for reviews
5. **Have fun** – Building great software is enjoyable!

**Need help?** Reach out to the team. We're here to support you! 🚀

---

## Appendix: Quick Decision Flowchart

```mermaid
graph TB
    START[I need to...]
    
    ADD_FEAT[Add a new feature]
    FIX_BUG[Fix a bug]
    ADD_UI[Create reusable UI]
    REFACTOR[Refactor code]
    
    Q1{Feature scope?}
    Q2{Where is bug?}
    Q3{Type of UI?}
    
    SA[Create in SA_APP]
    BA[Add to BA_APP]
    FEATURE_DIR[Update in features/]
    SHARED_UI[Add to shared/ui/]
    WIDGET[Create widget]
    THEME[Update theme]
    
    START --> ADD_FEAT
    START --> FIX_BUG
    START --> ADD_UI
    START --> REFACTOR
    
    ADD_FEAT --> Q1
    Q1 -->|Standalone| SA
    Q1 -->|Composite| BA
    
    FIX_BUG --> Q2
    Q2 -->|In feature| FEATURE_DIR
    Q2 -->|In shared| SHARED_UI
    
    ADD_UI --> Q3
    Q3 -->|Reusable component| WIDGET
    Q3 -->|Design system| THEME
    
    WIDGET --> SHARED_UI
    THEME --> SHARED_UI
```

Happy coding! 💻✨
