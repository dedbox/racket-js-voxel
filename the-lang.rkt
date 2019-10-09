#lang racket/base

(require racket/base
         syntax/parse/define
         voxel
         (for-syntax racket/base
                     syntax/parse))

(provide (except-out (all-from-out racket/base) #%module-begin)
         (all-from-out voxel)
         (rename-out [module-begin #%module-begin]))

(define-syntax-parser module-begin
  [(_ (~optional (~seq #:interactive? interactive?:boolean)
                 #:defaults ([interactive? #'#t]))
      (~optional (~seq #:web-port                 web-port:expr))
      (~optional (~seq #:web-socket-port   web-socket-port:expr))
      (~optional (~seq #:server-root-path server-root-path:expr))
      (~optional (~seq #:launch-browser?   launch-browser?:expr))
      form ...)
   #`(#%module-begin
      (require voxel/web-server
               voxel/web-socket-server)
      (#,@(if (syntax-e #'interactive?) #'(begin) #'(module+ main))
       (define server (web-server (~? web-port 8000)
                                  (~? launch-browser? #t)
                                  (~? server-root-path (collection-path "voxel"))))
       (current-web-socket
        (web-socket-server (~? web-socket-port 8001)))
       (sleep 0.1)
       form ...
       #,@(if (syntax-e #'interactive?)
              null
              (list #'(sync (current-web-socket))))))])
