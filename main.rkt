#lang racket/gui

(require net/rfc6455
         web-server/servlet
         web-server/servlet-env)

;;; ============================================================================

(define input-font-face "Droid Sans Mono")
(define input-font-size 12)
(define launch-browser? #t)

;;; ============================================================================

(define repl-canvas%
  (class editor-canvas%
    (inherit get-editor)
    (super-new)
    (define ctrl? #f)
    (define (send-repl)
      (thread (λ ()
                (define msg (send (get-editor) get-text))
                (printf "send-repl: ~a\n" msg)
                (channel-put out-ch msg))))
    (define/override (on-char event)
      (match* ((send event get-key-code)
               (send event get-key-release-code))
        [('control 'press) (set! ctrl? #t)]
        [(#\return 'press) (if ctrl? (send-repl) (super on-char event))]
        [('release 'control) (set! ctrl? #f)]
        [('release _) (void)]
        [(_ _) (super on-char event)]))))

(define frame (new frame%
                   [label "Voxel Tamagotchi"]
                   [ width 800]
                   [height 600]))

(define  input-canvas (new   repl-canvas% [parent frame]))
(define output-canvas (new editor-canvas% [parent frame]
                           [style '(no-focus)]
                           [min-height 100]
                           [stretchable-height #f]))

(define  input-text (new text%))
(define output-text (new text%))

(send  input-canvas set-editor  input-text)
(send output-canvas set-editor output-text)

(send frame show #t)
(send input-canvas focus)

;;; Menu Bar

(define menu-bar (new menu-bar% [parent frame]))

(define menu-file (new menu% [label "&File"] [parent menu-bar]))
(define menu-file-new
  (new menu-item%
       [label "&New"]
       [parent menu-file]
       [callback (λ _ (send input-text erase))]))
(define menu-file-open
  (new menu-item%
       [label "&Open"]
       [parent menu-file]
       [callback (λ _
                   (define path (get-file))
                   (when path
                     (send input-text erase)
                     (send input-text insert (file->string path))))]))
(define menu-file-save
  (new menu-item%
       [label "&Save"]
       [parent menu-file]
       [callback (λ _
                   (define path (put-file))
                   (when path
                     (with-output-to-file path
                       #:exists 'replace
                       (λ () (display (send input-text get-text))))))]))
(define menu-file-exit
  (new menu-item%
       [label "E&xit"]
       [parent menu-file]
       [callback (λ _ (exit))]))

(define menu-edit (new menu% [label "&Edit"] [parent menu-bar]))
(append-editor-operation-menu-items menu-edit #f)

(send input-text set-max-undo-history 100)

;;; Output Pane

(let* ([style-list (send input-text get-style-list)]
       [style (send style-list basic-style)]
       [delta (make-object style-delta%)]
       [delta (send delta set-delta-face         input-font-face)]
       [delta (send delta set-delta 'change-size input-font-size)])
  (send style-list replace-named-style "Standard"
        (send style-list find-or-create-style style delta)))

(define  in-ch (make-channel))
(define out-ch (make-channel))

(thread
 (λ ()
   (let loop ()
     (send output-text insert (format "~a\n" (channel-get in-ch)))
     (loop))))

;;; WebSocket Server

(ws-serve
 #:port 8001
 (λ (c s)
   (let loop ()
     (sync (handle-evt out-ch (curry ws-send! c))
           (replace-evt (ws-recv-evt c) (curry channel-put-evt in-ch)))
     (loop))))

;;; Web Server

(define (start request)
  (response/xexpr
   '(html (head (title "Voxel Tamagotchi")
                (script ([src "bundle.js"]))
                (link ([rel "stylesheet"] [type "text/css"] [href "style.css"])))
          (body))))

(thread
 (λ ()
   (serve/servlet start
                  #:port 8000
                  #:servlet-path "/"
                  #:server-root-path "./"
                  #:launch-browser? launch-browser?)))

;;; ----------------------------------------------------------------------------

(module+ test
  (require net/url)

  ;; give the servers a chance to start
  (sleep 0.1)

  (define c (ws-connect (string->url "ws://localhost:8001/"))))
