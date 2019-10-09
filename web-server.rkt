#lang racket/base

(require web-server/servlet
         web-server/servlet-env)

(provide web-server)

(define (start request)
  (response/xexpr
   '(html (head (title "#lang voxel")
                (script ([src "bundle.js"]))
                (link ([rel "stylesheet"] [type "text/css"] [href "style.css"])))
          (body))))

(define (web-server [port 8000]
                    [launch-browser? #t]
                    [server-root-path (collection-path "voxel")])
  (thread
   (λ ()
     (serve/servlet start
                    #:port port
                    #:servlet-path "/"
                    #:server-root-path server-root-path
                    #:launch-browser? launch-browser?))))
