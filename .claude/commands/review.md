Run a full pre-merge review of the current branch. This is the quality gate before merging to main.

## 1. Branch Check
- Show current branch name (must NOT be main)
- Show how many commits ahead of main
- Show `git diff --stat main` (files changed summary)

## 2. Code Generation
- Run `dart run build_runner build --delete-conflicting-outputs`
- Report: clean or errors

## 3. Code Formatting
- Run `dart format . --set-exit-if-changed`
- If files need formatting, format them and report which files were fixed
- After formatting, check if there are uncommitted changes from the format fix

## 4. Static Analysis
- Run `flutter analyze`
- Report: number of issues (errors, warnings, infos)
- If there are errors, list them all

## 5. Tests
- Run `flutter test`
- Report: total tests, passed, failed, skipped
- If any failed, list the failures

## 6. Build Check
- Run `flutter build apk --debug 2>&1 | tail -10`
- Report: success or failure

## 7. Security Check
- Run `git diff --cached --name-only` and `git diff --name-only`
- Check if any sensitive files are staged or modified:
  - google-services.json
  - .env files
  - any file with "key", "secret", "token", "password" in the name
- Report: clean or list the flagged files

## 8. Session Log Check
- Check if CLAUDE.md has been updated with a session log entry for the current branch
- Report: found or missing

## 9. Final Verdict
Give a summary table:

| Check | Status | Notes |
|-------|--------|-------|
| Branch | ✅/❌ | branch name |
| Code Gen | ✅/❌ | |
| Formatting | ✅/❌ | |
| Analysis | ✅/❌ | issue count |
| Tests | ✅/❌ | pass/fail count |
| Build | ✅/❌ | |
| Security | ✅/❌ | |
| Session Log | ✅/❌ | |

Then give a clear verdict:
- If ALL checks pass: "✅ REVIEW PASSED — Safe to merge to main"
- If ANY check fails: "❌ REVIEW FAILED — Fix the issues above before merging"

Do NOT merge. Do NOT push. Just report.
