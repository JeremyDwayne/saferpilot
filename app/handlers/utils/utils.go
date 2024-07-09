package utils

import (
	"net/http"

	"github.com/a-h/templ"
)

type Utility struct {
	Response http.ResponseWriter
	Request  *http.Request
}

type HandlerFunc func(util *Utility) error

func (util *Utility) Text(status int, msg string) error {
	util.Response.WriteHeader(status)
	util.Response.Header().Set("Content-Type", "text/plain")
	_, err := util.Response.Write([]byte(msg))
	return err
}

var errorHandler = func(util *Utility, err error) {
	util.Text(http.StatusInternalServerError, err.Error())
}

func (util *Utility) Render(c templ.Component) error {
	return c.Render(util.Request.Context(), util.Response)
}

func Handler(h HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		util := &Utility{
			Response: w,
			Request:  r,
		}
		if err := h(util); err != nil {
			if errorHandler != nil {
				errorHandler(util, err)
				return
			}
			util.Text(http.StatusInternalServerError, err.Error())
		}
	}
}
