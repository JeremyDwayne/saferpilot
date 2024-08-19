package handlers

import (
	"net/http"
	"saferpilot/internal/views"
)

func GetLoginHandler() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		err := views.Login().Render(r.Context(), w)
		if err != nil {
			http.Error(w, "Error rendering landing page", http.StatusInternalServerError)
			return
		}
	}
}

func PostLoginHandler() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		email := r.FormValue("email")
		password := r.FormValue("password")
	}
}
