package middleware

import "net/http"

func CSPMiddleware(next http.Handler) http.Handler {
	return nil
}

func TextHTMLMiddleware(next http.Handler) http.Handler {
	return nil
}
