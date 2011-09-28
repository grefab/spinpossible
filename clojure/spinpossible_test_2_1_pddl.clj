(define (problem spinpossible-test-2-1)
  (:domain spinpossible-2-1)
  (:objects t0 t1 )
  (:init (tile t0) (tile t1)
         (at-0 t1) (upright t1) (at-1 t0) (upright t0))
  (:goal (and (at-0 t0) (upright t0) (at-1 t1) (upright t1))))


