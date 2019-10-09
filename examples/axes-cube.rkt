#lang racket/base

(require glm
         voxel
         voxel/web-server
         voxel/web-socket-server)

(define serv (web-server))
(define sock (web-socket-server))

(sleep 0.1)

;;; origin

(draw #:socket sock (voxel (^ 0 0 0) black))

;;; axes

(for ([x (in-range 1 4)]) (draw #:socket sock (voxel (^ x 0 0)   red)))
(for ([y (in-range 1 4)]) (draw #:socket sock (voxel (^ 0 y 0) green)))
(for ([z (in-range 1 4)]) (draw #:socket sock (voxel (^ 0 0 z) blue )))

;;; area

(for* ([x (in-range 1 4)]
       [y (in-range 1 4)]
       [z (in-range 1 4)])
  (draw #:socket sock (voxel (^ x y z) white)))

;;; walls

(for* ([y (in-range 1 4)]
       [z (in-range 1 4)])
  (draw #:socket sock (voxel (^ 0 y z) cyan)))

(for* ([x (in-range 1 4)]
       [z (in-range 1 4)])
  (draw #:socket sock (voxel (^ x 0 z) magenta)))

(for* ([x (in-range 1 4)]
       [y (in-range 1 4)])
  (draw #:socket sock (voxel (^ x y 0) yellow)))
