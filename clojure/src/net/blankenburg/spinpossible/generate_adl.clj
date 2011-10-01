(ns net.blankenburg.spinpossible.generate-adl
  (:use net.blankenburg.spinpossible.spinpossible2))

(defn bit-seq [x n]
  "Returns a lazy sequence of 0 and 1 indicating whether the bits in x are set.
   n is the number of bits."
  (lazy-seq
    (cons 
      (bit-and x 1) 
      (if (< 1 n) 
        (bit-seq (bit-shift-right x 1) (dec n))))))

(def identity-field
  (memoize 
    (fn [width height]
      (apply vector (range (* width height))))))

(defn p-par [object]
  (str " ?" object))

(defn p-pred [pred & x]
  (str "(" pred " " x ")"))

(defn p-not [predicate]
  (str "(not " predicate ")"))

(defn p-and [& expressions]
  (str "(and " (apply str expressions) ")"))

(defn p-action [a-name parameters precondition effect ]
  (str "(:action " a-name " :parameters " parameters " :precondition " precondition " :effect " effect))

(defn filter-str [string-seq]
  (apply str (filter seq string-seq)))

(defn t [number]
  (str "t" number))

(defn par-t [number]
  (p-par (t number)))

(defn at [position parameter]
  (p-pred (str "at " position parameter)))

(defn upright [parameter]
  (p-pred "upright" parameter))

(defn- get-parameter [position new-position]
  (if (not= position new-position)
    (par-t position)))

(defn- filter-map [fn & more]
  (filter-str (map fn more))) 

(defn- flipped? [position new-position]
  (not= position new-position))

(defn- moved? [position new-position]
  (not= position (* -1 new-position)))

(defn p-type [ptype & parameters]
  (str parameters " - " ptype))

(def tile-type "tile")
(def position-type "position")

(defn tile [& parameters]
  (p-type tile-type parameters))

(def get-action [width height spin] 
  [new-positions (move (identity-field

(comment
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

