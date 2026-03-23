Prepare current changes for a pull request:
1. Run `dart run build_runner build --delete-conflicting-outputs`
2. Run `dart format .`
3. Run `flutter analyze` — fix all issues
4. Run `flutter test` — ensure all pass
5. Show `git diff --stat` summary
6. Suggest a descriptive commit message
7. Ask if I want to commit and push
