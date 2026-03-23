Scaffold a new HMS feature module. Ask me for:
1. Feature/module name (e.g., "rent", "electricity", "inventory")
2. What data fields the main model needs
3. What screens are needed

Then generate the full module structure under lib/features/<module_name>/:
- models/ — Freezed model with schemaVersion, createdAt, updatedAt, updatedBy fields included
- providers/ — @riverpod annotated provider with Firestore CRUD
- screens/ — ConsumerWidget screen with Design System components
- widgets/ — Any module-specific widgets needed

After generating:
1. Run `dart run build_runner build --delete-conflicting-outputs`
2. Run `flutter analyze`
3. Report what was created
