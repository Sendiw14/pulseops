.PHONY: setup dev web api test check build
setup:
	corepack pnpm install
	cd apps/api && mix deps.get
dev:
	@echo "Run 'make api' and 'make web' in separate terminals."
web:
	corepack pnpm --filter @pulseops/web dev
api:
	cd apps/api && mix phx.server
test:
	corepack pnpm --filter @pulseops/web typecheck
	cd apps/api && mix test
check:
	corepack pnpm --filter @pulseops/web typecheck
	cd apps/api && mix format --check-formatted
build:
	corepack pnpm --filter @pulseops/web build
