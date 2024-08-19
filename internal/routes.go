package internal

import (
	"net/http"
	"saferpilot/internal/handlers"

	"github.com/go-chi/chi/v5"
)

func InitializeRoutes(router *chi.Mux) {
	// Static Assets
	fs := http.FileServer(http.Dir("./public/assets"))
	router.Handle("/public/assets/*", http.StripPrefix("/public/assets/", fs))

	// Auth not required
	router.Group(func(app chi.Router) {
		// app.Use(<auth middleware>) that allows anyone

		app.HandleFunc("/", handlers.LandingHandler())
		app.HandleFunc("/login", handlers.GetLoginHandler())
	})

	// Auth required
	router.Group(func(app chi.Router) {
		// app.Use(<auth middleware>) that is restricted to logged in users
	})

	// Elevated Auth required
	router.Group(func(app chi.Router) {
		// app.Use(<auth middleware>) that is restricted to logged in admins
	})
}
