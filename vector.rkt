#lang racket/base

(require glm)

(provide (all-defined-out))

(define-values (^ ^+ ^- ^* ^/ ^? ^list)
  (values ivec3 ivec+ ivec- ivec* ivec/ ivec3? ivec->list))

(define point? ^?)

(define-values ($ $+ $- $* $/ $? $list)
  (values vec3 vec+ vec- vec* vec/ vec3? vec->list))

(define color? $?)
