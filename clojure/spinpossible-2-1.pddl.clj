(define (domain spinpossible-2-1)
  (:requirements :strips)
  (:predicates
    (tile ?t)
    (upright ?t)
    (flipped ?t)
    (at-0 ?t)
    (at-1 ?t))
  
  (:action 
    move-su
    :parameters (?t)
    :precondition
      (and 
        (tile ?t)
        (upright ?t))
    :effect
      (and 
        (not (upright ?t))
        (flipped ?t)))
             
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
        (not (flipped ?t))))

  (:action 
    move-u0u1
    :parameters (?t0 ?t1)
    :precondition
      (and 
        (tile ?t0)
        (tile ?t1)
        (at-0 ?t0)
        (at-1 ?t1)
        (upright ?t0)
        (upright ?t1))
    :effect
      (and 
        (not (upright ?t0)) (flipped ?t0)
        (not (upright ?t1)) (flipped ?t1)
        (not (at-0 ?t0)) (at-1 ?t0)
        (not (at-1 ?t1)) (at-0 ?t1)))

    (:action 
    move-f0u1
    :parameters (?t0 ?t1)
    :precondition
      (and 
        (tile ?t0)
        (tile ?t1)
        (at-0 ?t0)
        (at-1 ?t1)
        (flipped ?t0)
        (upright ?t1))
    :effect
      (and 
        (not (flipped ?t0)) (upright ?t0)
        (not (upright ?t1)) (flipped ?t1)
        (not (at-0 ?t0)) (at-1 ?t0)
        (not (at-1 ?t1)) (at-0 ?t1)))

     (:action 
    move-u0f1
    :parameters (?t0 ?t1)
    :precondition
      (and 
        (tile ?t0)
        (tile ?t1)
        (at-0 ?t0)
        (at-1 ?t1)
        (upright ?t0)
        (flipped ?t1))
    :effect
      (and 
        (not (upright ?t0)) (flipped ?t0)
        (not (flipped ?t1)) (upright ?t1)
        (not (at-0 ?t0)) (at-1 ?t0)
        (not (at-1 ?t1)) (at-0 ?t1)))
   
     (:action 
    move-f0f1
    :parameters (?t0 ?t1)
    :precondition
      (and 
        (tile ?t0)
        (tile ?t1)
        (at-0 ?t0)
        (at-1 ?t1)
        (flipped ?t0)
        (flipped ?t1))
    :effect
      (and 
        (not (flipped ?t0)) (upright ?t0)
        (not (flipped ?t1)) (upright ?t1)
        (not (at-0 ?t0)) (at-1 ?t0)
        (not (at-1 ?t1)) (at-0 ?t1))))
   