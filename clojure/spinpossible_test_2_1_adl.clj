(define (problem spinpossible-test-2-1)
  (:domain spinpossible-2-1)
  (:objects
    p0 p1 - position
    t0 t1 - tile)
  (:init (adjunct p0 p1)
         (at p0 t1) (upright t1) (at p1 t0) (upright t0))
  (:goal (and (at p0 t0) (upright t0) (at p1 t1) (upright t1))))


