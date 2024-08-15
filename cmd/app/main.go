package main

import (
	"net/http"
	"os"
	"saferpilot/internal"

	"github.com/charmbracelet/log"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
)

func main() {
	router := chi.NewRouter()

	port := os.Getenv("HTTP_LISTEN_ADDR")

	router.Use(middleware.Logger)
	router.Use(middleware.Heartbeat("/healthcheck"))

	internal.InitializeRoutes(router)

	env := os.Getenv("ENV")
	url := "http://localhost:7331"

	if env == "production" {
		url = "http://localhost" + port
	}

	log.Info("Server Listening", "env", env, "url", url)
	http.ListenAndServe(port, router)
}
