#lang racket/base

(require glm
         racket/contract
         voxel/color
         voxel/voxel
         voxel/web-socket-server)

(provide (all-defined-out))

(define/contract (draw #:socket [sock (current-web-socket)] a)
  (->* (voxelizable?) (#:socket web-socket-server?) void?)
  (define (do-voxel v)
    (hasheq 'action "voxel"
            'position (ivec->list (voxel-position v))
            'color (if (voxel-active? v) (html-color (voxel-color v)) 0)))
  (for ([v (in-list (voxelize a))])
    (web-socket-send #:socket sock (do-voxel v))))
