package main

import (
	"errors"
	"fmt"
	"log/slog"
	"net/http"
	"os"
	"os/signal"
	"saferpilot/app"
	"syscall"
	"time"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
)

func main() {
	logger := slog.New(slog.NewJSONHandler(os.Stdout, nil))
	r := chi.NewRouter()

	r.Use(middleware.RequestID)
	r.Use(middleware.RealIP)
	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)
	r.Use(middleware.Timeout(60 * time.Second))

	fileServer := http.FileServer(http.Dir("./public/assets"))
	r.Handle("/public/assets/*", http.StripPrefix("/public/assets/", fileServer))
	app.InitializeRoutes(r)

	killSig := make(chan os.Signal, 1)

	signal.Notify(killSig, os.Interrupt, syscall.SIGTERM)

	listenAddr := os.Getenv("HTTP_LISTEN_ADDR")
	server := &http.Server{
		Addr:    listenAddr,
		Handler: r,
	}

	err := server.ListenAndServe()

	if errors.Is(err, http.ErrServerClosed) {
		fmt.Printf("server closed\n")
	} else if err != nil {
		fmt.Printf("error starting server: %s\n", err)
		os.Exit(1)
	}

	url := "http://localhost" + listenAddr

	logger.Info(fmt.Sprintf("application running in %s at %s\n", os.Getenv("APP_ENV"), url), slog.String("port", listenAddr))
}
