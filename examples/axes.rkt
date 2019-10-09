#lang voxel

;;; The default configuration:
;;
;; #:interactive? #t
;; #:web-port 8000
;; #:web-socket-port 8001
;; #:server-root-path (collection-path "voxel")
;; #:launch-browser? #t
;;
;; (define-colors
;;   ;;        R G B
;;   [white   (1 1 1)]
;;   [red     (1 0 0)]
;;   [green   (0 1 0)]
;;   [blue    (0 0 1)]
;;   [cyan    (0 1 1)]
;;   [magenta (1 0 1)]
;;   [yellow  (1 1 0)]
;;   [black   (0 0 0)])

(draw (voxel (^ 0 0 0) black))

(for ([x (in-range 1 4)]) (draw (voxel (^ x 0 0) red  )))
(for ([y (in-range 1 4)]) (draw (voxel (^ 0 y 0) green)))
(for ([z (in-range 1 4)]) (draw (voxel (^ 0 0 z) blue )))
