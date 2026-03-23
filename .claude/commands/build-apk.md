Build the HMS Flutter APK:
1. Run `flutter clean`
2. Run `flutter pub get`
3. Run `dart run build_runner build --delete-conflicting-outputs`
4. Run `dart format .`
5. Run `flutter analyze` — fix any issues found
6. Run `flutter test` — ensure all tests pass
7. Build: `flutter build apk --release`
8. Report the APK file path and size
