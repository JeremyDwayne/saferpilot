package handlers

import (
	"net/http"
	"saferpilot/internal/views"
)

func LandingHandler() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		err := views.Landing().Render(r.Context(), w)
		if err != nil {
			http.Error(w, "Error rendering landing page", http.StatusInternalServerError)
			return
		}
	}
}
