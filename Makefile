ifneq (,$(wildcard ./.env))
    include .env
    export
endif

MAIN_PATH = tmp/bin/main
SYNC_ASSETS_COMMAND =	@go run github.com/air-verse/air@latest \
											--build.cmd "templ generate --notify-proxy" \
											--build.bin "true" \
											--build.delay "100" \
											--build.exclude_dir "" \
											--build.include_dir "public" \
											--build.include_ext "js,css" \
											--screen.clear_on_rebuild true \
											--log.main_only true

templ:
	@templ generate --watch --proxy="http://localhost$(HTTP_LISTEN_ADDR)" --open-browser=false

server:
	@go run github.com/air-verse/air@latest \
	--build.cmd "go build --tags dev -o ${MAIN_PATH} ./cmd/app/" --build.bin "${MAIN_PATH}" --build.delay "100" \
	--build.exclude_dir "node_modules" \
	--build.include_ext "go" \
	--build.stop_on_error "false" \
	--misc.clean_on_exit true \
	--screen.clear_on_rebuild true \
	--log.main_only true

watch-assets:
	@pnpx tailwindcss -i app/assets/app.css -o ./public/assets/styles.css --watch   

watch-esbuild:
	@pnpx esbuild app/assets/index.js --bundle --outdir=public/assets --watch

sync_assets:
	${SYNC_ASSETS_COMMAND}

dev:
	@make -j5 templ server watch-assets watch-esbuild sync_assets

build:
	@pnpx tailwindcss -i app/assets/app.css -o ./public/assets/styles.css
	@pnpx esbuild app/assets/index.js --bundle --outdir=public/assets
	@go build -o bin/app_prod cmd/app/main.go
	@echo "compiled you application with all its assets to a single binary => bin/app_prod"
