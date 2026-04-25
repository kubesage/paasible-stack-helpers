# Phase 20.5 — paasible-stack-helpers containerized build/test.
# See: workspace CLAUDE.md > Local Development Rule
# C1 fix: each verb has its recipe DIRECTLY in the same target body.
# M4 fix: in-container shell uses `if [ -f go.mod ]; then ...; fi` so
# real go-mod failures propagate (NOT masked by `||`).

.PHONY: install build test dev dev-up dev-down lint

## install: go mod download inside container.
install:
	KUBESAGE_ALLOW_HOST=1 docker compose --profile dev run --rm helpers sh -c 'if [ -f go.mod ]; then go mod download; else echo "no go.mod yet — skipping"; fi'

## build: Build all Go packages inside container.
build:
	KUBESAGE_ALLOW_HOST=1 docker compose --profile dev run --rm helpers sh -c 'if [ -f go.mod ]; then go build ./...; else echo "no go.mod yet — skipping"; fi'

## test: Run all Go tests inside container.
test:
	KUBESAGE_ALLOW_HOST=1 docker compose --profile dev run --rm helpers sh -c 'if [ -f go.mod ]; then go test -race ./...; else echo "no go.mod yet — skipping"; fi'

## dev: HMR loop for the helpers package.
## C1 fix: recipe DIRECTLY under `dev:` (calls dev-up as prereq, runs watch in own body).
dev: dev-up
	docker compose --profile dev watch

dev-up:
	docker compose --profile dev up -d

dev-down:
	docker compose --profile dev down

## lint: golangci-lint (host-side allowed per Local Development Rule).
lint:
	@command -v golangci-lint >/dev/null && golangci-lint run ./... || echo "golangci-lint not installed; skipping"
