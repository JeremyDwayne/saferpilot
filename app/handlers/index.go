package handlers

import (
	"net/http"
	"saferpilot/app/views"
)

type IndexHandler struct{}

func NewIndexHandler() *IndexHandler {
	return &IndexHandler{}
}

func (h *IndexHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	component := views.Index()
	err := component.Render(r.Context(), w)
	if err != nil {
		http.Error(w, "error rendering template", http.StatusInternalServerError)
		return
	}
}
