package middleware

import (
	"net/http"
	"time"

	"github.com/charmbracelet/log"
)

type wrappedWriter struct {
	http.ResponseWriter
	statusCode int
}

func (w *wrappedWriter) WriteHeader(statusCode int) {
	w.ResponseWriter.WriteHeader(statusCode)
	w.statusCode = statusCode
}

func Logging(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		start := time.Now()
		wrapped := &wrappedWriter{
			ResponseWriter: w,
			statusCode:     http.StatusOK,
		}
		next.ServeHTTP(wrapped, r)
		if wrapped.statusCode >= 400 {
			log.Error("", "status", wrapped.statusCode, "method", r.Method, "path", r.URL.Path, "elapsed", time.Since(start))
		} else {
			log.Info("", "status", wrapped.statusCode, "method", r.Method, "path", r.URL.Path, "elapsed", time.Since(start))
		}
	})
}
