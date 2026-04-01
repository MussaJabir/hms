Ship the current branch: run checks then merge to main if all pass.

## Quick Checks (fail fast)
1. Confirm current branch is NOT main — abort if on main
2. `flutter analyze` — abort if errors found
3. `flutter test` — abort if failures
4. Check for sensitive files in diff: `git diff main --name-only | grep -iE "(google-services|\.env|secret|token|password)" || echo "clean"` — abort if found

## If all pass → Merge
5. `git checkout main`
6. `git merge <branch-name>`
7. `git push origin main`
8. `git branch -d <branch-name>`
9. In CLAUDE.md session log, change "⏳ in progress" to "✅ merged" for this branch
10. `git add CLAUDE.md && git commit -m "docs: <branch-name> merged" && git push origin main`

## Report
Show one-line summary: "✅ Shipped <branch-name> → main (X tests passed, 0 issues)"
Or: "❌ Failed — [reason]"
