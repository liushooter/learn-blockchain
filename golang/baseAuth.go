package main

import (
	"bytes"
	"encoding/base64"
	"io"
	"log"
	"net/http"
	"strings"
)

type ViewFunc func(http.ResponseWriter, *http.Request)

func BasicAuth(f ViewFunc, user, passwd []byte) ViewFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		basicAuthPrefix := "Basic "

		// 获取 request header
		auth := r.Header.Get("Authorization")
		// 如果是 http basic auth
		if strings.HasPrefix(auth, basicAuthPrefix) {
			// 解码认证信息
			payload, err := base64.StdEncoding.DecodeString(
				auth[len(basicAuthPrefix):],
			)
			if err == nil {
				pair := bytes.SplitN(payload, []byte(":"), 2)
				if len(pair) == 2 && bytes.Equal(pair[0], user) &&
					bytes.Equal(pair[1], passwd) {
					// 执行被装饰的函数
					f(w, r)
					return
				}
			}
		}

		// 认证失败，提示 401 Unauthorized
		// Restricted 可以改成其他的值
		w.Header().Set("WWW-Authenticate", `Basic realm="Restricted"`)
		// 401 状态码
		w.WriteHeader(http.StatusUnauthorized)
	}
}

// 需要被保护的内容
func HelloServer(w http.ResponseWriter, req *http.Request) {
	io.WriteString(w, "hello, world!\n")
}

func main() {
	user := []byte("user")
	passwd := []byte("passwd")

	// 装饰需要保护的 handler
	http.HandleFunc("/hello", BasicAuth(HelloServer, user, passwd))

	log.Println("Listen :8000")

	err := http.ListenAndServe(":5000", nil)

	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}

//https://mozillazg.com/2015/04/go-add-http-basic-auth-for-http-server.html
