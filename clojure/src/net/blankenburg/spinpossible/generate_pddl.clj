(ns net.blankenburg.spinpossible.generate-pddl
  (:use net.blankenburg.spinpossible.spinpossible2))

(defn bit-seq [x n]
  "Returns a lazy sequence of 0 and 1 indicating whether the bits in x are set.
   n is the number of bits."
  (lazy-seq
    (cons 
      (bit-and x 1) 
      (if (< 1 n) 
        (bit-seq (bit-shift-right x 1) (dec n))))))

(def default-field
  (memoize 
    (fn [width height]
      (apply vector (range (* width height))))))

(defn get-par-pre-eff [position width height [r1 r2]]
  (let [tile (str "?t" position)
        pre-at (str "(at-" position " " tile ")")
        eff-at (str "(not " pre-at ") (at-" (* -1 (new-element position (default-field width height) width height r1 r2)) " " tile ")")]
    [tile pre-at eff-at]))


(comment
(defn all-possible-moves [width height [[x1 y1] [x2 y2]]]
  "Generates a pddl action for the given move."
  (str "(:action" 
    "move-" x1 y1 x2 y2
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
        (not (at-1 ?t1)) (at-0 ?t1)))))