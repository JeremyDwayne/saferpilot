package handlers

import (
	"net/http"
	"saferpilot/internal/views"
)

func LoginHandler() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		err := views.Login().Render(r.Context(), w)
		if err != nil {
			http.Error(w, "Error rendering landing page", http.StatusInternalServerError)
			return
		}
	}
}
