#lang racket/base

(require racket/generic
         racket/match
         voxel/color
         voxel/vector
         voxel/voxel)

(provide (all-defined-out))

(struct run (axis position length color)
  #:transparent
  #:name vx:run
  #:constructor-name run
  #:methods gen:voxelizable
  [(define (voxelize R)
     (match-define (vx:run axis position length color) R)
     (for/list ([k length])
       (voxel (^+ position (^* axis k)) color)))])

(define (X-run position length [color white])
  (run (^ 1 0 0) position length color))

(define (Y-run position length [color white])
  (run (^ 0 1 0) position length color))

(define (Z-run position length [color white])
  (run (^ 0 0 1) position length color))
