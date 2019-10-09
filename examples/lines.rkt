#lang voxel

(draw (line (^  1 3 0) (^  3 3 0) red))
(draw (line (^ -1 3 0) (^ -3 3 0) cyan))

(draw (line (^ 0 4 0) (^ 0 6 0) green))
(draw (line (^ 0 2 0) (^ 0 0 0) magenta))

(draw (line (^ 0 3  1) (^ 0 3  3) blue))
(draw (line (^ 0 3 -1) (^ 0 3 -3) yellow))

(draw (line (^ 1 3  3) (^ 3 3  1) black))
(draw (line (^ 3 3 -1) (^ 1 3 -3) black))
(draw (line (^ -1 3 -3) (^ -3 3 -1) black))
(draw (line (^ -3 3  1) (^ -1 3  3) black))

(draw (line (^ 0 2  3) (^ 0 0  1) white))
(draw (line (^ 0 2 -3) (^ 0 0 -1) white))
(draw (line (^  1 0 0) (^  3 2 0) white))
(draw (line (^ -1 0 0) (^ -3 2 0) white))
