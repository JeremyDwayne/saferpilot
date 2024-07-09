package app

import (
	"saferpilot/app/handlers"

	"github.com/go-chi/chi/v5"
)

func InitializeRoutes(router *chi.Mux) {
	router.Group(func(r chi.Router) {
		r.Get("/", handlers.NewIndexHandler().ServeHTTP)
	})
}
