#lang racket/base

(require racket/generic
         racket/match
         voxel/color
         voxel/run
         voxel/vector
         voxel/voxel)

(provide (all-defined-out))

(struct cuboid (filled? position width height depth color)
  #:transparent
  #:name vx:cuboid
  #:constructor-name make-cuboid
  #:methods gen:voxelizable
  [(define/generic gen-voxelize voxelize)
   (define (voxelize C)
     (if (cuboid-filled? C)
         (voxelize-filled-cuboid C)
         (voxelize-hollow-cuboid C)))
   (define (voxelize-filled-cuboid C)
     (match-define (vx:cuboid _ position width height depth color) C)
     (apply append (map gen-voxelize
                        (for*/list ([y (in-range height)]
                                    [z (in-range  depth)])
                          (X-run (^+ position (^ 0 y z)) width color)))))
   (define (voxelize-hollow-cuboid C)
     (match-define (vx:cuboid _ position width height depth color) C)
     (define bottom
       (apply append (map gen-voxelize
                          (for/list ([z (in-range depth)])
                            (X-run (^+ position (^ 0 0 z)) width color)))))
     (define top
       (apply append (map gen-voxelize
                          (for/list ([z (in-range depth)])
                            (X-run (^+ position (^ 0 (- height 1) z)) width color)))))
     (define sides
       (append (apply append
                      (map gen-voxelize
                           (append
                            (for/list ([y (in-range 1 (- height 1))])
                              (X-run (^+ position (^ 0 y 0)) width color))
                            (for/list ([y (in-range 1 (- height 1))])
                              (X-run (^+ position (^ 0 y (- depth 1))) width color)))))
               (apply append (for*/list ([y (in-range 1 (- height 1))]
                                         [z (in-range 1 (-  depth 1))])
                               (list (voxel (^+ position (^      0      y z)) color)
                                     (voxel (^+ position (^ (- width 1) y z)) color))))))
     (append bottom sides top))])

(define (hollow-cuboid position width height depth [color white])
  (make-cuboid #f position width height depth color))

(define (filled-cuboid position width height depth [color white])
  (make-cuboid #t position width height depth color))
