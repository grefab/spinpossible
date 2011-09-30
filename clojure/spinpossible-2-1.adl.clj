(define (domain spinpossible-2-1)
  (:requirements :adl :types)
  (:types position tile)
  (:predicates
    (upright ?t - tile)
    (at ?p - position ?t - tile))
  
  (:action 
    :parameters (?t - tile)
    :effect
      (when (upright ?t) (not (upright ?t)))
      (when (not (upright ?t)) (upright ?t)))
             
  (:action 
    move-0-1
    :parameters (?p0 ?p1 - position 
                 ?t0 ?t1 - tile)
    :precondition
      (and
        (at ?p0 ?t0) (at ?p1 ?t1))
    :effect
      (and
        (at ?p0 ?t1) (not (at ?p0 ?t0))´
        (at ?p1 ?t0) (not (at ?p1 ?t1))
        (forall (?t - tile) 
                (when (upright ?t) (not (upright ?t)))
                (when (not (upright ?t)) (upright ?t))))))
        
