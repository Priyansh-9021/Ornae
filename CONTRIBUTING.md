# Contributing

## Branch naming

```
feature/short-description
fix/short-description
chore/short-description
```

Branch off `main`, keep branches short-lived and scoped to one feature/fix.

## Commit messages

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add JWT refresh token endpoint
fix: correct cart total calculation
chore: update backend dependencies
docs: add setup instructions to README
```

## Pull requests

1. Keep PRs small and scoped — one feature or fix per PR.
2. Fill out the PR template (what changed, how to test, related issue).
3. Link the related issue with `Closes #<issue-number>`.
4. Make sure CI passes before requesting review.
5. At least one approval required before merge.
6. Use **squash and merge** — this is the repo default.

## Local setup

See the root [README.md](./README.md) for full setup instructions using Docker Compose.

## Code ownership

- `backend/` — reviewed by the backend maintainer
- `frontend/`, `chatbot/` — reviewed by the frontend/chatbot maintainer

See `.github/CODEOWNERS` for the current mapping.
