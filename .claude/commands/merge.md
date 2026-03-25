Merge the current branch to main. Only run this AFTER /pre-merge passes.

1. Get the current branch name and store it
2. `git checkout main`
3. `git merge <branch-name>`
4. `git push origin main`
5. `git branch -d <branch-name>`
6. In CLAUDE.md, find the session log entry for this branch and change "⏳ in progress" to "✅ merged"
7. `git add CLAUDE.md && git commit -m "docs: session log — <branch-name> merged" && git push origin main`
8. Show `git log --oneline -10`
9. Report: "Merged and pushed. Ready for next branch."
