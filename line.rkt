#lang racket/base

(require glm
         racket/generic
         racket/match
         voxel/color
         voxel/vector
         voxel/voxel)

(provide (struct-out vx:line) line 26-line 6-line)

(struct line (maker start end color)
  #:transparent
  #:name vx:line
  #:constructor-name make-line
  #:methods gen:voxelizable
  [(define (voxelize L)
     (match-define (vx:line maker start end color) L)
     (maker start end color))])

(define (line #:type [type 26-line] start end [color white])
  (make-line (make-type type) start end color))

(define ((make-type type) p1 p2 color)
  (match-define (list Δx Δy Δz) (^list (^- p2 p1)))
  (match-define (list dx dy dz) (map abs (list Δx Δy Δz)))
  (match-define (list x1 y1 z1) (^list p1))
  (match-define (list x2 y2 z2) (^list p2))
  (define-syntax-rule (rearrange (a1 b1 c1) (a2 b2 c2) (d e f) (g h i))
    (for/list ([v (in-list (type (^ a1 b1 c1) (^ a2 b2 c2) color))])
      (match-define (vx:voxel (app ^list (list d e f)) color active?) v)
      (voxel (^ g h i) color active?)))
  (cond [(and (>= dx dy) (>= dx dz))
         (if (>= Δx 0)
             (rearrange (   x1  y1 z1) (   x2  y2 z2) (x y z) (   x  y z))
             (rearrange ((- x1) y1 z1) ((- x2) y2 z2) (x y z) ((- x) y z)))]
        [(and (>= dy dx) (>= dy dz))
         (if (>= Δy 0)
             (rearrange (   y1  x1 z1) (   y2  x2 z2) (y x z) (x    y  z))
             (rearrange ((- y1) x1 z1) ((- y2) x2 z2) (y x z) (x (- y) z)))]
        [(and (>= dz dx) (>= dz dy))
         (if (>= Δz 0)
             (rearrange (   z1  y1 x1) (   z2  y2 x2) (z y x) (x y    z))
             (rearrange ((- z1) y1 x1) ((- z2) y2 x2) (z y x) (x y (- z))))]
        [else (raise 'impossible!)]))

(define (26-line p1 p2 color)
  (match-define (list x1 y1 z1) (^list p1))
  (match-define (list x2 y2 z2) (^list p2))
  (define Δx (- x2 x1))
  (define Δy (abs (- y2 y1)))
  (define Δz (abs (- z2 z1)))
  (define ysign (if (>= y2 y1) 1 -1))
  (define zsign (if (>= z2 z1) 1 -1))
  (define-values (yinc1 yinc2) (values (* 2 Δy) (* 2 (- Δy Δx))))
  (define-values (zinc1 zinc2) (values (* 2 Δz) (* 2 (- Δz Δx))))
  (let loop ([x x1]
             [y y1]
             [z z1]
             [dy (- (* 2 Δy) Δx)]
             [dz (- (* 2 Δz) Δx)])
    (if (> x x2)
        null
        (let-values ([(δy δdy) (if (< dy 0) (values 0 yinc1) (values ysign yinc2))]
                     [(δz δdz) (if (< dz 0) (values 0 zinc1) (values zsign zinc2))])
          (cons (voxel (^ x y z) color)
                (loop (+ x 1) (+ y δy) (+ z δz) (+ dy δdy) (+ dz δdz)))))))

(define (6-line p1 p2 color)
  (define-values (A B C) (apply values (^list (^- p2 p1))))
  (define A-2 (* 2 A))
  (define B-2 (* 2 B))
  (define C-2 (* 2 C))
  (let loop ([n (+ A B C)]
             [v (^ 0 0 0)]
             [e-xy (- B A)]
             [e-xz (- C A)]
             [e-zy (- B C)])
    (if (<= n 0)
        null
        (cons (voxel (^+ p1 v) color)
              (if (negative? e-xy)
                  (if (negative? e-xz)
                      (loop (- n 1)
                            (^+ v (^ 1 0 0))
                            (+ e-xy B-2)
                            (+ e-xz C-2)
                            e-zy)
                      (loop (- n 1)
                            (^+ v (^ 0 0 1))
                            e-xy
                            (- e-xz A-2)
                            (+ e-zy B-2)))
                  (if (negative? e-zy)
                      (loop (- n 1)
                            (^+ v (^ 0 0 1))
                            e-xy
                            (- e-xz A-2)
                            (+ e-zy B-2))
                      (loop (- n 1)
                            (^+ v (^ 0 1 0))
                            (- e-xy A-2)
                            e-xz
                            (- e-zy C-2))))))))
