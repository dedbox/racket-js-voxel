#lang racket/base

(require racket/generic
         voxel/color
         voxel/vector)

(provide (all-defined-out))

(define-generics voxelizable
  (voxelize voxelizable))

(struct voxel (position color active?)
  #:transparent
  #:name vx:voxel
  #:constructor-name make-voxel
  #:methods gen:voxelizable
  [(define voxelize list)])

(define (voxel position [color white] [active? #t])
  (make-voxel position color active?))
