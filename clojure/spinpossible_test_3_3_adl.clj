(define (problem spinpossible-test-3-3)
  (:domain spinpossible-3-3)
  (:objects
    p0 p1 p2 p3 p4 p5 p6 p7 p8 - position
    t0 t1 t2 t3 t4 t5 t6 t7 t8 - tile)
  (:init (adjunct p0 p1 ) (adjunct p0 p3 ) 
         (adjunct p1 p2 ) (adjunct p1 p4 ) 
         (adjunct p2 p5 ) 
         (adjunct p3 p4 ) (adjunct p3 p6 ) 
         (adjunct p4 p5 ) (adjunct p4 p7 ) 
         (adjunct p5 p8 ) 
         (adjunct p6 p7 ) 
         (adjunct p7 p8 ) 
         (at p0 t6) (upright t6) (at p1 t3) (upright t3) (at p2 t4)
         (at p3 t8) (upright t8) (at p4 t1)              (at p5 t2)
         (at p6 t7)              (at p7 t5)              (at p8 t0)  (upright t0)) 
  (:goal (and (at p0 t0 ) (at p1 t1 ) (at p2 t2 ) (at p3 t3 ) (at p4 t4 ) (at p5 t5 ) (at p6 t6 ) (at p7 t7 ) (at p8 t8 )
              (upright t0 ) (upright t1 ) (upright t2 ) (upright t3 ) (upright t4 ) (upright t5 ) (upright t6 ) (upright t7 ) (upright t8 ) )))


