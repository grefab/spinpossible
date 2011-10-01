(define (domain spinpossible-2-1)
  (:requirements :adl :typing)
  (:types position tile)
  (:predicates
    (upright ?t - tile)
    (at ?p - position ?t - tile)
    (adjunct ?p0 ?p1 - position))
  
  (:action 
    flip
    :parameters (?t - tile)
    :effect
      (and
        (when (upright ?t) (not (upright ?t)))
        (when (not (upright ?t)) (upright ?t))))
             
  (:action 
    move-0-1
    :parameters (?p0 ?p1 - position 
                 ?t0 ?t1 - tile)
    :precondition
      (and
        (at ?p0 ?t0) (at ?p1 ?t1)
        (adjunct ?p0 ?p1))
    :effect
      (and
        (at ?p0 ?t1) (not (at ?p0 ?t0))
        (at ?p1 ?t0) (not (at ?p1 ?t1))
        (when (upright ?t0) (not (upright ?t0)))
        (when (not (upright ?t0)) (upright ?t0))
        (when (upright ?t1) (not (upright ?t1)))
        (when (not (upright ?t1)) (upright ?t1)))))
        
