#lang racket

(require json
         net/rfc6455)

(provide current-web-socket
         web-socket-server
         web-socket-server?
         web-socket-send web-socket-receive
         web-socket-send-evt web-socket-receive-evt)

(define current-web-socket (make-parameter #f))

(struct web-socket-server (in-ch out-ch done-latch)
  #:name vt:web-socket-server
  #:constructor-name make-web-socket-server
  #:property prop:evt (struct-field-index done-latch))

(define (web-socket-server [port 8001])
  (define  in-ch (make-channel))
  (define out-ch (make-channel))
  (define done-sema (make-semaphore))
  (define done-latch (handle-evt (thread (λ () (sync done-sema))) void))
  (define (send-evt c)
    (handle-evt
     out-ch
     (λ (msg) (ws-send! c (with-output-to-string (λ () (write-json msg)))))))
  (define (recv-evt c)
    (replace-evt
     (ws-recv-evt c)
     (λ (str)
       (if (eof-object? str)
           (semaphore-post done-sema)
           (let ([msg (with-input-from-string str (λ () (read-json)))])
             (channel-put-evt in-ch msg))))))
  (ws-serve #:port port
            (λ (c s) (let loop () (sync (send-evt c) (recv-evt c)) (loop))))
  (make-web-socket-server in-ch out-ch done-latch))

(define (web-socket-send #:socket [sock (current-web-socket)] msg)
  (channel-put (web-socket-server-out-ch sock) msg))

(define (web-socket-receive #:socket [sock (current-web-socket)])
  (channel-get (web-socket-server-in-ch sock)))

(define (web-socket-send-evt #:socket [sock (current-web-socket)] msg)
  (channel-put-evt (web-socket-server-out-ch sock) msg))

(define (web-socket-receive-evt #:socket [sock (current-web-socket)])
  (web-socket-server-in-ch sock))
