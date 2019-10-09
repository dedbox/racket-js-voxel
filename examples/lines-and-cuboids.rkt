#lang voxel

;;; sky

(draw (hollow-cuboid (^ -10 -2 -10) 20 12 20 cyan))

;;; origin

(draw (voxel (^ 0 0 0) black))

;;; axes

(define (draw-axis v color)
  (draw (line v (^* v 4) color)))

(draw-axis (^ 1 0 0)   red)
(draw-axis (^ 0 1 0) green)
(draw-axis (^ 0 0 1)  blue)

;;; area

(draw (filled-cuboid (^ 1 1 1) 4 4 4 white))

;;; walls

(draw (filled-cuboid (^ 0 1 1) 1 4 4    cyan))
(draw (filled-cuboid (^ 1 0 1) 4 1 4 magenta))
(draw (filled-cuboid (^ 1 1 0) 4 4 1  yellow))
