# HMS — Home Management System

## Project Overview
HMS is a family household management app for managing rental properties (2 grounds, ~15 rooms), electricity monitoring, water bills, household inventory, children's school expenses, and family finances. Built for daily use on Android by a small family (2-3 users).

## Tech Stack
- Frontend: Flutter 3.41.x (Dart 3.11.x) — Android only
- Backend: Firebase (Firestore + Auth) — Spark plan (free tier)
- State Management: Riverpod 3.x with code generation (@riverpod + riverpod_generator)
- Routing: GoRouter with type-safe named routes and role-based guards
- Models: Freezed + json_serializable (immutable, auto JSON serialization)
- Notifications: flutter_local_notifications (100% local, no Cloud Functions)
- Charts: fl_chart for consumption and financial graphs
- Offline: Firestore native offline persistence (enablePersistence)
- NO Firebase Storage — contract photos stored locally on device only

## Architecture Pattern — FOLLOW THIS EXACTLY
lib/
├── core/                    # Shared across all modules
│   ├── providers/           # Shared Riverpod providers (auth, currentGround, connectivity)
│   ├── services/            # Firebase Auth service, Firestore CRUD service, notification service, recurring transaction engine, data migration service, activity logging service
│   ├── models/              # Shared models (user, ground, app_config)
│   ├── widgets/             # Design System components (AppCard, AlertCard, SummaryTile, QuickForm, StatusBadge, EmptyState, LoadingShimmer, OfflineBanner)
│   ├── theme/               # App theme, colors, typography, spacing
│   ├── utils/               # Helpers (TZS formatter, date utils, validators)
│   └── router/              # GoRouter configuration with route guards
├── features/                # Feature modules (one folder per module)
│   ├── auth/                # Login, role system, user management
│   │   ├── models/
│   │   ├── providers/
│   │   ├── screens/
│   │   └── widgets/
│   ├── dashboard/           # Smart alerts, health score, monthly report, quick-add FAB
│   ├── grounds/             # Grounds, rental units, tenant profiles
│   ├── rent/                # Rent payment tracking
│   ├── electricity/         # Meter readings, consumption, TANESCO tariff
│   ├── water/               # Water bills, tenant contributions
│   ├── finance/             # Income, expenses, budgets, financial reports
│   ├── inventory/           # Household stock management
│   ├── children/            # School expense tracking per child
│   ├── notifications/       # Notification center, scheduling, inbox
│   └── settings/            # App settings, activity logs, data management
└── main.dart                # App entry point with ProviderScope and Firebase init

## Module Pattern — Every feature follows this:
- **models/** — Freezed data classes with @freezed annotation, part files for .freezed.dart and .g.dart
- **providers/** — @riverpod annotated providers and notifiers, part files for .g.dart
- **screens/** — ConsumerWidget or ConsumerStatefulWidget (NOT StatefulWidget)
- **widgets/** — Module-specific reusable widgets

## Riverpod Rules
- Use @riverpod annotation for ALL providers (code generation, not manual)
- Use `Ref` parameter (Riverpod 3.x style), NOT the old `ref` on build
- Shared providers live in core/providers/ (currentGroundProvider, authStateProvider, connectivityProvider)
- Module providers live in features/<module>/providers/
- Use AsyncNotifier for anything involving Firestore queries
- Use StreamProvider for real-time Firestore listeners (e.g., alert feeds)
- Run `dart run build_runner build --delete-conflicting-outputs` after creating/modifying providers or models

## Firestore Rules
- Use SUBCOLLECTIONS, not flat top-level collections
- Path pattern: grounds/{groundId}/rental_units/{unitId}/meter_readings/{readingId}
- Every document includes: schemaVersion (int), createdAt (Timestamp), updatedAt (Timestamp), updatedBy (String)
- camelCase for all Firestore field names
- Queries scoped by groundId using the currentGroundProvider

## Data Validation Rules
- Phone numbers: Tanzanian format (07XX or 06XX, 10 digits)
- National ID: 20 characters (NIDA format)
- Currency: TZS, always positive, formatted with thousand separators
- Meter readings: current must be >= previous (unless meter reset confirmed)
- Dates: lease end > move-in date, due dates in the future

## UI Rules
- Use Design System components from core/widgets/ — never build one-off cards or tiles
- Every form uses QuickForm pattern: smart defaults, numeric keyboard for amounts, max 30 seconds to complete
- One-tap actions for common operations (mark rent paid, update stock quantity)
- Confirmation dialogs ONLY for destructive actions (delete), never for saves
- Success feedback via snackbar, not blocking dialogs
- Support light and dark themes
- Currency display: TZS throughout, formatted with intl package

## Offline Behavior
- Firestore offline persistence enabled at app startup
- All screens must render from Firestore cache when offline
- All forms must submit offline (Firestore queues writes automatically)
- OfflineBanner widget shows connectivity state
- Local notifications work regardless of connectivity

## Testing Requirements
- Unit tests for all calculation logic (consumption, tariffs, budgets, health score)
- Unit tests for all Firestore service methods
- Widget tests for all Design System components
- Integration tests for core flows (login → dashboard → record data)

## Build & Deploy
- Single APK build: flutter build apk --release
- Version format: v*.*.* in pubspec.yaml
- Run `dart format .` before committing
- Run `flutter analyze` — must pass with zero issues
- Run `flutter test` — all tests must pass

## Currency & Locale
- All monetary values in TZS (Tanzanian Shillings)
- Date format: dd/MM/yyyy
- Time format: 24-hour (HH:mm)
- Locale: en_TZ where applicable

## Git Workflow — MANDATORY
- EVERY phase, feature, or setup task gets its own branch
- Branch naming: `setup/claude-config`, `phase-0/foundation`, `phase-0.5/design-system`, `phase-1/auth`, `feature/rent-tracking`, `fix/meter-validation`, etc.
- NEVER commit directly to `main` — always branch, build, test, then merge
- Workflow for every task:
  1. `git checkout -b <branch-name>` — create branch from main
  2. Do the work, commit with descriptive messages along the way
  3. Run format, analyze, test — all must pass
  4. `git checkout main && git merge <branch-name>` — merge to main
  5. `git push origin main` — push to remote
  6. `git branch -d <branch-name>` — clean up local branch
- Commit message format: `phase-X: short description` (e.g., `phase-0: scaffold project structure and configure Riverpod`)
- Push to GitHub after every completed phase/feature merge to main

## GitHub & Authentication
- GitHub tokens are configured in the shell environment (~/.bashrc or /bin/bash profile)
- Git credentials are already set up — do NOT ask for tokens or authentication
- If a git push fails with auth errors, remind me to check my token instead of trying to fix it yourself
- Remote origin: https://github.com/MussaJabir/hms.git

## Claude Skills — USE THEM
- Always check for and utilize any globally installed Claude skills available in ~/.claude/skills/
- Before writing code for common patterns (frontend design, document generation, etc.), check if a relevant skill exists that provides best practices
- Skills help prevent mistakes — always prefer skill-guided approaches over improvising
- If a skill conflicts with HMS-specific rules in this CLAUDE.md, the HMS rules take priority

## Available Global Skills (check ~/.claude/skills/)
- flutter-dependency-updater — use when checking/updating pubspec.yaml dependencies
- tdd — use for all new features and bug fixes (RED-GREEN-REFACTOR cycle)
- frontend-design — use when building UI components (check against Design System rules above)
- ui-ux-pro-max — use for complex UI/UX design decisions
- tech-debt-tracker — use periodically to assess code quality
- planning-with-files — use for multi-step phase planning
- tourism-saas — relevant if HMS expands to property management SaaS
- dependency-auditor — run before any major release
- performance-profiler — use if app feels slow

## DO NOT
- Use Firebase Storage (we're on Spark plan, Storage requires Blaze)
- Use Cloud Functions (all notifications are local)
- Use Provider package (we use Riverpod, not Provider)
- Use Hive or Isar (Firestore handles offline caching natively)
- Create manual providers — always use @riverpod code generation
- Use snake_case for Firestore field names (use camelCase)
- Build custom widgets when a Design System component exists
- Skip the schemaVersion field on any Firestore document
- Suggest paid services or packages
- Commit directly to main — always use feature/phase branches
- Ask for GitHub tokens or credentials — they're already configured in the shell

## Development Session Log

### 2026-03-24
- Branch: `phase-0.1/firebase-config` — Purged google-services.json from git history (public repo security fix), configured Firebase Core + Firestore + Auth in Android Gradle, created main.dart with Firebase init + Firestore offline persistence + ProviderScope + GoRouter, created placeholder HomeScreen as ConsumerWidget, ran build_runner code generation ✅ merged

### 2026-03-25 — Phase 0.1 Completion
- Branch: `phase-0.1/android-settings` — App display name set to "HMS", verified Kotlin package path matches com.dutch.hms, confirmed all Android settings correct ✅ merged
- **Phase 0.1 — Project Initialization: COMPLETE** ✅
- Branch: `setup/review-agent` — Created /review slash command (automated pre-merge quality gate) and /merge slash command (automated merge-to-main workflow) ✅ merged
- Branch: `fix/rename-review-command` — Renamed /review to /pre-merge to avoid collision with global pr-review-expert skill, updated /merge reference ✅ merged
- Branch: `phase-0.2/theme` — Created app theme system (AppColors light/dark, AppTypography with TZS amount styles, AppSpacing, AppTheme with light/dark ThemeData), updated main.dart and HomeScreen to use theme ✅ merged
- Branch: `phase-0.2/riverpod-core-providers` — Created shared Riverpod providers: authStateProvider (Firebase auth stream), currentGroundProvider (ground selection notifier), connectivityProvider (online/offline stream), barrel export ✅ merged
- Branch: `phase-0.2/firestore-service` — Created generic FirestoreService with CRUD + streaming + auto metadata (createdAt, updatedAt, updatedBy, schemaVersion), Riverpod provider, unit tests ✅ merged
- Branch: `phase-0.2/auth-service` — Created AuthService with sign in/out, account creation, password reset, auth state stream, AuthException with user-friendly error mapping, Riverpod provider, services barrel export, unit tests with mocked FirebaseAuth ✅ merged
- Branch: `phase-0.2/models-base` — Created Freezed base models: AppUser (with isSuperAdmin/isAdmin getters), Ground, AppConfig (with nested TanescoTier for TANESCO tariffs), ActivityLog; barrel export at models.dart; added build.yaml with explicit_to_json: true for correct nested serialization; 19 unit tests across AppUser, Ground, AppConfig all passing; Freezed 3.x requires `abstract class` with _$Mixin pattern ✅

### Phase 0.3 — Core Services

- Branch: `phase-0.3/activity-log-service` — Created ActivityLogService with log/query/stream methods, depends on FirestoreService, Riverpod provider, unit tests with fake Firestore (12 tests passing) ✅ merged
- Branch: `phase-0.3/recurring-transaction-engine` — Created RecurringConfig and RecurringRecord Freezed models, RecurringTransactionService with monthly generation (idempotent), payment tracking, overdue detection, Riverpod provider, unit tests (18 tests passing) ✅ merged
- Branch: `phase-0.3/data-migration-service` — Created Migration and MigrationStatus models, DataMigrationService with version checking and ordered transforms (idempotent), MigrationRegistry for future schema changes, Riverpod provider, unit tests (17 tests passing) ✅ merged
- Branch: `phase-0.3/notification-service` — Created NotificationService with scheduling (one-time, weekly, immediate), cancel methods, Firestore-backed notification history for in-app inbox, unread count streaming, NotificationType enum, ScheduledNotification model, Riverpod provider, unit tests (22 tests passing) ✅ merged

### Phase 0.5 — Design System

- Branch: `phase-0.5/app-card` — Created AppCard component (title, subtitle, leading icon, trailing text/widget, bottom widget, tap/long-press, chevron), AppCardShimmer loading skeleton, widget tests ✅ merged
- Branch: `phase-0.5/alert-card` — Created AlertCard component (severity levels: critical/warning/info/success, color-coded left border, icon, dismiss, action button, timestamp), AlertSeverity enum, timeAgo utility, widget and unit tests ✅ merged
- Branch: `phase-0.5/summary-tile` — Created SummaryTile component (standard/compact modes, trend arrows, value coloring), TrendDirection enum, TZS currency formatter utility (full/short formats), widget and unit tests ✅ merged
- Branch: `phase-0.5/status-badge` — Created StatusBadge pill component (normal/small sizes), PaymentStatus enum with 11 statuses and color mapping, fromString factory for Firestore values, widget tests ✅ merged
- Branch: `phase-0.5/quick-form` — Created form components: HmsTextField, HmsCurrencyField (live TZS formatting with TzsInputFormatter), HmsDatePicker (dd/MM/yyyy), HmsDropdown, Validators utility (phone, NIDA, meter reading, currency, dates), widget and unit tests ✅ merged
- Branch: `phase-0.5/empty-state` — Created EmptyState component (standard/compact modes, icon, title, message, action button), EmptyStatePresets with 13 pre-configured states for all modules, widget tests ✅ merged
- Branch: `phase-0.5/loading-shimmer` — Created shimmer loading system: ShimmerEffect (animated gradient), ShimmerBox (placeholder shape), ShimmerCard/ShimmerAlertCard/ShimmerSummaryTile (matching real component layouts), ShimmerList (multiple items), barrel export, widget tests ✅ merged
- Branch: `phase-0.5/offline-banner` — Created OfflineBanner (animated show/hide, offline/syncing states, watches connectivityProvider), ConnectionStatus (dot indicator for AppBar), widgets barrel export for entire Design System, updated HomeScreen demo, widget tests ✅ merged
- **Phase 0.5 — Design System: COMPLETE** ✅

### Phase 1 — Authentication & User Management

- Branch: `phase-1/login-screen` — Created login screen with email/password fields, form validation, AuthService integration, password visibility toggle, forgot password dialog, error display, loading states, Design System components, widget tests ✅ merged
- Branch: `phase-1/role-model-and-service` — Created UserService (CRUD for user profiles, role management), FirstTimeSetupService (initial Super Admin creation), Riverpod providers (currentUserProfile, isSuperAdmin, allUsers, firstTimeSetup), barrel exports, unit tests ✅ merged
- Branch: `phase-1/auth-guard-routing` — Created AuthState enum (loading/firstTimeSetup/unauthenticated/authenticated), AuthNotifier (Riverpod-derived auth state), pure authRedirect function, GoRouter with auth guards, SplashScreen, FirstTimeSetupScreen (4-field form with validation), screens barrel export, 20 tests (13 router + 7 widget) ✅ merged
- Branch: `fix/first-time-setup-existing-account` — Fixed first-time setup flow: handle "email already in use" gracefully with redirect to login, added "Already have an account?" link on setup screen, added "First time?" link on login screen, added timeout fallback on superAdminExists check to default to login screen ✅ merged
- Branch: `phase-1/user-management-screen` — Created UserManagementScreen (user list with stream, role badges, empty state), AddUserScreen (create family member with sign-out-after-creation re-auth handling), UserDetailScreen (role change dialog, activity log nav, password reset, delete with confirmation, self-guard), UserActivityLogScreen (filtered activity logs with timeAgo), userProfile family provider, GoRouter routes for /users/*, Super Admin access guard per screen, updated HomeScreen with temp "Manage Users" button (SA only), 21 widget tests; fixed 2 navigation bugs: (1) GoRouter redirect blocked /login during firstTimeSetup state, (2) AuthNotifier checked isFirstTimeSetup before auth — caused post-login loading freeze; AuthNotifier now checks authenticated user first ✅
- Branch: `phase-1/firestore-security-rules` — Created firestore.rules with role-based access (Super Admin full, Admin create/update, immutable activity logs, deny-all default), deployment guide at docs/FIRESTORE_RULES.md, security test plan at test/security/firestore_rules_test.dart ✅
- **Phase 1 — Authentication & User Management: COMPLETE** ✅

### Phase 2 — Dashboard

- Branch: `phase-2/grounds-selector` — Created GroundFilter enum, GroundsSelector segmented toggle widget, updated currentGroundProvider to use GroundFilter, added to HomeScreen ✅ merged
- Branch: `phase-2/health-score` — Created HealthScore Freezed model (weighted calculation with inactive module redistribution, label, color), HealthScoreService (mock data, independent per-module score methods), health score Riverpod providers, HealthScoreCard widget (circular arc progress, score label, breakdown bottom sheet with per-factor progress bars), added to HomeScreen between GroundsSelector and content, 30 unit and widget tests ✅ merged
- Branch: `phase-2/quick-add-fab` — Created QuickAddFab and QuickAddBottomSheet (4 quick actions: expense, meter reading, rent payment, inventory), placeholder navigation with snackbar, added FAB to HomeScreen ✅ merged
- Branch: `phase-2/monthly-report` — Created MonthlyReport model (net position, rent rate, per-ground breakdown), ExpenseCategory and OverdueItem models, MonthlyReportService (mock data), monthly report provider, MonthlyReportScreen (net position, income/expenses, rent rate, top expenses, overdue items, per-ground comparison, month navigation), route added, linked from HomeScreen ✅ merged
- Branch: `phase-2/alert-feed` — Created DashboardAlert Freezed model (in-memory, no Firestore), AlertGeneratorService (placeholder per-module generators + severity sorter), alertsProvider with 3 sample alerts (critical/warning/info), AlertFeed ConsumerStatefulWidget with dismiss, 10-alert cap, empty state, added to HomeScreen in scrollable CustomScrollView; 9 tests (4 model + 5 widget) ✅ merged
- Branch: `phase-2/dashboard-layout` — Finalized HomeScreen layout (AppBar with notification bell badge + ConnectionStatus, Drawer with navigation and sign out, scrollable body with GroundsSelector → HealthScore → AlertFeed sections), DashboardSectionHeader widget, barrel exports for dashboard widgets and screens ✅ merged
- **Phase 2 — Dashboard: COMPLETE** ✅

### Phase 3 — Grounds, Units & Tenants

- Branch: `phase-3/grounds-crud` — Created RentalUnit model, GroundService (CRUD with Firestore), ground providers (stream all/by ID), GroundsListScreen, AddGroundScreen (create/edit), GroundDetailScreen, GoRouter routes, Drawer navigation, barrel exports, tests ✅ merged
- Branch: `phase-3/rental-units-crud` — Created RentalUnitService (CRUD with subcollection paths), rental unit providers (stream all/by ID/count/vacant), UnitListScreen, AddUnitScreen (create/edit with currency field), updated GroundDetailScreen with real unit data, updated GroundsListScreen with unit counts, GoRouter routes, tests ✅ merged
- Branch: `phase-3/tenant-profiles` — Created Tenant and CommunicationLog models, TenantService (CRUD with subcollection, auto unit status update, communication log), tenant providers, TenantDetailScreen (profile, lease status, communication log with add note), AddTenantScreen (Tanzanian phone/NIDA validation, date validation), updated UnitListScreen to show tenant names, GoRouter routes, tests ✅ merged
- Branch: `phase-3/tenant-move-out` — Created Settlement model, MoveOutService (creates settlement, deactivates recurring configs, sets unit vacant), MoveOutScreen (form with outstanding balances, confirmation), SettlementHistoryScreen, updated TenantDetailScreen with move-out action, GoRouter routes, tests ✅ merged
