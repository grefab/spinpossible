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

(defn p-par [object]
  (str " ?" object))

(defn p-pred [pred x]
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
  (p-pred (str "at-" position) parameter))

(defn upright [parameter]
  (p-pred "upright" parameter))

(defn flipped [parameter]
  (p-pred "flipped" parameter))

(defn- get-parameter [position new-position]
  (if (not= position new-position)
    (par-t position)))

(defn- filter-map [fn & more]
  (filter-str (map fn more))) 

(defn- flipped? [position new-position]
  (not= position new-position))

(defn- moved? [position new-position]
  (not= position (* -1 new-position)))

(defn- get-flip-precondition [position flip-indicator]
  (if (pos? flip-indicator) (upright (par-t position)) (flipped (par-t position))))
      
(defn- get-flip-effect [position flip-indicator]
  (str (p-not (get-flip-precondition position flip-indicator)) (get-flip-precondition position (- 1 flip-indicator))))

(defn- get-precondition [position new-position flip-indicator]
  (if (flipped? position new-position)
    (str (get-flip-precondition position flip-indicator)
         (if (moved? position new-position) (at position (par-t position)))))) 

(defn spin-action [width height [[x1 y1] [x2 y2]] flip-number]
  (let [positions (default-field 3 3)
        new-positions (move positions 3 3 [[x1 y1] [x2 y2]])
        flip-seq (bit-seq flip-number (* (inc (- x2 x1)) (inc (- y2 y1))))] []
    (p-action 
      (str "spin-" x1 "-" y1 "--" x2 "-" y2)
      (map-on-positions get-parameter positions new-positions)
      (map-on-positions get-precondition positions new-positions   
      nil)))

  
(comment
(defn- get-at-preconditions [position new-position]
  (if (not= position (* -1 new-position))
    (let [?tp (par-t position)
          pre-at (at position ?tp)
          eff-at (str (at new-position ?tp) (p-not (at position ?tp)))]
      [?tp pre-at eff-at])))


(defn spin-action [width height [[x1 y1] [x2 y2]] flip-number]
  (let [positions (default-field 3 3)
        new-positions (move positions 3 3 [[x1 y1] [x2 y2]])
        flip-seq (bit-seq flip-number (* (inc (- x2 x1)) (inc (- y2 y1))))] []
    (p-action 
      (str "spin-" x1 "-" y1 "--" x2 "-" y2)
      (map-on-positions get-parameter positions new-positions)
      nil nil)))

      
  (let [new-position (* -1 (new-element position (default-field width height) width height r1 r2))]
 


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
        (not (at-1 ?t1)) (at-0 ?t1))))))