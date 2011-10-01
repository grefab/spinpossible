(define (domain spinpossible-3-3)
  (:requirements :adl :typing)
  (:types position tile)
  (:predicates
    (upright ?t - tile)
    (at ?p - position ?t - tile)
    (adjunct ?p0 ?p1 - position))

(:action move-1X1
   :parameters ( ?p0 - position  ?t0 - tile )
   :precondition (and (at ?p0 ?t0 ) )
   :effect (and (when (upright ?t0 ) (not (upright ?t0 ) ))(when (not (upright ?t0 ) )(upright ?t0 ) )))

(:action move-1X2
   :parameters ( ?p0 ?p3 - position  ?t0 ?t3 - tile )
   :precondition (and (at ?p0 ?t0 ) (at ?p3 ?t3 ) (adjunct ?p0 ?p3 ) )
   :effect (and (at ?p3 ?t0 ) (not (at ?p0 ?t0 ) )(at ?p0 ?t3 ) (not (at ?p3 ?t3 ) )(when (upright ?t0 ) (not (upright ?t0 ) ))(when (not (upright ?t0 ) )(upright ?t0 ) )(when (upright ?t3 ) (not (upright ?t3 ) ))(when (not (upright ?t3 ) )(upright ?t3 ) )))

(:action move-1X3
   :parameters ( ?p0 ?p3 ?p6 - position  ?t0 ?t3 ?t6 - tile )
   :precondition (and (at ?p0 ?t0 ) (at ?p3 ?t3 ) (at ?p6 ?t6 ) (adjunct ?p0 ?p3 ) (adjunct ?p3 ?p6 ) )
   :effect (and (at ?p6 ?t0 ) (not (at ?p0 ?t0 ) )(at ?p0 ?t6 ) (not (at ?p6 ?t6 ) )(when (upright ?t0 ) (not (upright ?t0 ) ))(when (not (upright ?t0 ) )(upright ?t0 ) )(when (upright ?t3 ) (not (upright ?t3 ) ))(when (not (upright ?t3 ) )(upright ?t3 ) )(when (upright ?t6 ) (not (upright ?t6 ) ))(when (not (upright ?t6 ) )(upright ?t6 ) )))

(:action move-2X2
   :parameters ( ?p0 ?p1 ?p3 ?p4 - position  ?t0 ?t1 ?t3 ?t4 - tile )
   :precondition (and (at ?p0 ?t0 ) (at ?p1 ?t1 ) (at ?p3 ?t3 ) (at ?p4 ?t4 ) (adjunct ?p0 ?p1 ) (adjunct ?p0 ?p3 ) (adjunct ?p1 ?p4 ) (adjunct ?p3 ?p4 ) )
   :effect (and (at ?p4 ?t0 ) (not (at ?p0 ?t0 ) )(at ?p3 ?t1 ) (not (at ?p1 ?t1 ) )(at ?p1 ?t3 ) (not (at ?p3 ?t3 ) )(at ?p0 ?t4 ) (not (at ?p4 ?t4 ) )(when (upright ?t0 ) (not (upright ?t0 ) ))(when (not (upright ?t0 ) )(upright ?t0 ) )(when (upright ?t1 ) (not (upright ?t1 ) ))(when (not (upright ?t1 ) )(upright ?t1 ) )(when (upright ?t3 ) (not (upright ?t3 ) ))(when (not (upright ?t3 ) )(upright ?t3 ) )(when (upright ?t4 ) (not (upright ?t4 ) ))(when (not (upright ?t4 ) )(upright ?t4 ) )))

(:action move-2X3
   :parameters ( ?p0 ?p1 ?p3 ?p4 ?p6 ?p7 - position  ?t0 ?t1 ?t3 ?t4 ?t6 ?t7 - tile )
   :precondition (and (at ?p0 ?t0 ) (at ?p1 ?t1 ) (at ?p3 ?t3 ) (at ?p4 ?t4 ) (at ?p6 ?t6 ) (at ?p7 ?t7 ) (adjunct ?p0 ?p1 ) (adjunct ?p0 ?p3 ) (adjunct ?p1 ?p4 ) (adjunct ?p3 ?p4 ) (adjunct ?p3 ?p6 ) (adjunct ?p4 ?p7 ) (adjunct ?p6 ?p7 ) )
   :effect (and (at ?p7 ?t0 ) (not (at ?p0 ?t0 ) )(at ?p6 ?t1 ) (not (at ?p1 ?t1 ) )(at ?p4 ?t3 ) (not (at ?p3 ?t3 ) )(at ?p3 ?t4 ) (not (at ?p4 ?t4 ) )(at ?p1 ?t6 ) (not (at ?p6 ?t6 ) )(at ?p0 ?t7 ) (not (at ?p7 ?t7 ) )(when (upright ?t0 ) (not (upright ?t0 ) ))(when (not (upright ?t0 ) )(upright ?t0 ) )(when (upright ?t1 ) (not (upright ?t1 ) ))(when (not (upright ?t1 ) )(upright ?t1 ) )(when (upright ?t3 ) (not (upright ?t3 ) ))(when (not (upright ?t3 ) )(upright ?t3 ) )(when (upright ?t4 ) (not (upright ?t4 ) ))(when (not (upright ?t4 ) )(upright ?t4 ) )(when (upright ?t6 ) (not (upright ?t6 ) ))(when (not (upright ?t6 ) )(upright ?t6 ) )(when (upright ?t7 ) (not (upright ?t7 ) ))(when (not (upright ?t7 ) )(upright ?t7 ) )))

(:action move-3X2
   :parameters ( ?p0 ?p1 ?p2 ?p3 ?p4 ?p5 - position  ?t0 ?t1 ?t2 ?t3 ?t4 ?t5 - tile )
   :precondition (and (at ?p0 ?t0 ) (at ?p1 ?t1 ) (at ?p2 ?t2 ) (at ?p3 ?t3 ) (at ?p4 ?t4 ) (at ?p5 ?t5 ) (adjunct ?p0 ?p1 ) (adjunct ?p0 ?p3 ) (adjunct ?p1 ?p2 ) (adjunct ?p1 ?p4 ) (adjunct ?p2 ?p5 ) (adjunct ?p3 ?p4 ) (adjunct ?p4 ?p5 ) )
   :effect (and (at ?p5 ?t0 ) (not (at ?p0 ?t0 ) )(at ?p4 ?t1 ) (not (at ?p1 ?t1 ) )(at ?p3 ?t2 ) (not (at ?p2 ?t2 ) )(at ?p2 ?t3 ) (not (at ?p3 ?t3 ) )(at ?p1 ?t4 ) (not (at ?p4 ?t4 ) )(at ?p0 ?t5 ) (not (at ?p5 ?t5 ) )(when (upright ?t0 ) (not (upright ?t0 ) ))(when (not (upright ?t0 ) )(upright ?t0 ) )(when (upright ?t1 ) (not (upright ?t1 ) ))(when (not (upright ?t1 ) )(upright ?t1 ) )(when (upright ?t2 ) (not (upright ?t2 ) ))(when (not (upright ?t2 ) )(upright ?t2 ) )(when (upright ?t3 ) (not (upright ?t3 ) ))(when (not (upright ?t3 ) )(upright ?t3 ) )(when (upright ?t4 ) (not (upright ?t4 ) ))(when (not (upright ?t4 ) )(upright ?t4 ) )(when (upright ?t5 ) (not (upright ?t5 ) ))(when (not (upright ?t5 ) )(upright ?t5 ) )))

(:action move-3X3
   :parameters ( ?p0 ?p1 ?p2 ?p3 ?p4 ?p5 ?p6 ?p7 ?p8 - position  ?t0 ?t1 ?t2 ?t3 ?t4 ?t5 ?t6 ?t7 ?t8 - tile )
   :precondition (and (at ?p0 ?t0 ) (at ?p1 ?t1 ) (at ?p2 ?t2 ) (at ?p3 ?t3 ) (at ?p4 ?t4 ) (at ?p5 ?t5 ) (at ?p6 ?t6 ) (at ?p7 ?t7 ) (at ?p8 ?t8 ) (adjunct ?p0 ?p1 ) (adjunct ?p0 ?p3 ) (adjunct ?p1 ?p2 ) (adjunct ?p1 ?p4 ) (adjunct ?p2 ?p5 ) (adjunct ?p3 ?p4 ) (adjunct ?p3 ?p6 ) (adjunct ?p4 ?p5 ) (adjunct ?p4 ?p7 ) (adjunct ?p5 ?p8 ) (adjunct ?p6 ?p7 ) (adjunct ?p7 ?p8 ) )
   :effect (and (at ?p8 ?t0 ) (not (at ?p0 ?t0 ) )(at ?p7 ?t1 ) (not (at ?p1 ?t1 ) )(at ?p6 ?t2 ) (not (at ?p2 ?t2 ) )(at ?p5 ?t3 ) (not (at ?p3 ?t3 ) )(at ?p3 ?t5 ) (not (at ?p5 ?t5 ) )(at ?p2 ?t6 ) (not (at ?p6 ?t6 ) )(at ?p1 ?t7 ) (not (at ?p7 ?t7 ) )(at ?p0 ?t8 ) (not (at ?p8 ?t8 ) )(when (upright ?t0 ) (not (upright ?t0 ) ))(when (not (upright ?t0 ) )(upright ?t0 ) )(when (upright ?t1 ) (not (upright ?t1 ) ))(when (not (upright ?t1 ) )(upright ?t1 ) )(when (upright ?t2 ) (not (upright ?t2 ) ))(when (not (upright ?t2 ) )(upright ?t2 ) )(when (upright ?t3 ) (not (upright ?t3 ) ))(when (not (upright ?t3 ) )(upright ?t3 ) )(when (upright ?t4 ) (not (upright ?t4 ) ))(when (not (upright ?t4 ) )(upright ?t4 ) )(when (upright ?t5 ) (not (upright ?t5 ) ))(when (not (upright ?t5 ) )(upright ?t5 ) )(when (upright ?t6 ) (not (upright ?t6 ) ))(when (not (upright ?t6 ) )(upright ?t6 ) )(when (upright ?t7 ) (not (upright ?t7 ) ))(when (not (upright ?t7 ) )(upright ?t7 ) )(when (upright ?t8 ) (not (upright ?t8 ) ))(when (not (upright ?t8 ) )(upright ?t8 ) ))))
        
