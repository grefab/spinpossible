(define (domain spinpossible-2-1)
  (:requirements :strips)
  (:predicates
    (tile ?t)
    (upright ?t)
    (flipped ?t)
    (at-0 ?t)
    (at-1 ?t))

  (:action 
    move-sf
    :parameters (?t)
    :precondition
      (and 
        (tile ?t)
        (flipped ?t))
    :effect
      (and 
        (upright ?t)
        (not (flipped ?t)))))
   