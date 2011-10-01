(ns net.blankenburg.spinpossible.generate-adl
  (:use net.blankenburg.spinpossible.spinpossible2))

(comment
  
  ;Actions look like this:
  
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

(defn p-par [object]
  (str " ?" object))

(defn p-pred [pred & x]
  (str "(" pred " " x") "))

(defn p-not [predicate]
  (str "(not " predicate ")"))

(defn p-and [& expressions]
  (str "(and " (apply str expressions) ")"))

(defn p-when [condition expression]
  (str "(when " condition expression ")"))

(defn p-action [a-name parameters precondition effect ]
  (str "(:action " a-name "\n\t :parameters " parameters "\n\t :precondition " precondition "\n\t :effect " effect ")\n\n"))

(defn filter-str [string-seq]
  (apply str (filter seq string-seq)))

(defn t [number]
  (str "t" number))

(defn p [number]
  (str "p" number))

(defn par-t [number]
  (p-par (t number)))

(defn par-p [number]
  (p-par (p number)))


(defn at [position tile]
  (p-pred (str "at" position tile)))

(defn adjunct [position1 position2]
  (p-pred (str "adjunct" position1 position2)))

(defn upright [parameter]
  (p-pred (str "upright" parameter)))

(defn- filter-map [fn & more]
  (filter-str (map fn more))) 

(defn p-type [ptype & parameters]
  (str (apply str parameters) " - " ptype))

(def tile-type "tile ")
(def position-type "position ")

(defn strmap [f & seqs]
  (apply str (apply map f seqs)))

(defn typed-parameters [type par-fn indices]
  (apply p-type type (strmap par-fn indices)))

(defn position-parameters [positions]
  (typed-parameters position-type par-p positions))

(defn tile-parameters [positions]
  (typed-parameters tile-type par-t positions))

(defn move-parameters [changed-positions]
  (str "(" (position-parameters changed-positions) (tile-parameters changed-positions) ")"))

(defn from-ats [changed-positions]
  (map at (map par-p changed-positions) (map par-t changed-positions))) 

(defn to-ats [changed-positions]
  (let [new-positions (reverse changed-positions)]
    (map at (map par-p new-positions) (map par-t changed-positions)))) 

(defn abs [x]
  (if (neg? x) (* -1 x) x))

(defn adjunct? [width height pos1 pos2]
  (let [[x1 y1] (xy-from-position pos1 width height)
        [x2 y2] (xy-from-position pos2 width height)]
    (or 
      (and (= x1 x2) (= 1 (abs (- y1 y2))))
      (and (= y1 y2) (= 1 (abs (- x1 x2)))))))

(defn adjuncts [width height positions]
  (filter-str 
    (flatten
      (for [pos1 positions]
        (for [pos2 (drop-while #(not= pos1 %) positions)]
          (if (adjunct? width height pos1 pos2) (adjunct (par-p pos1) (par-p pos2))))))))

(defn move-predicate [width height changed-positions]
  (str "(and " (apply str (from-ats changed-positions)) (adjuncts width height changed-positions) ")"))

(defn flip [position]
  (let [upright (upright (par-t position))
        not-upright (p-not upright)]
  (str (p-when upright not-upright) (p-when not-upright upright))))

(defn move-effect [changed-positions]
  (str "(and "
       (strmap #(if (not= %1 %2) (str %2 (p-not %1))) (from-ats changed-positions) (to-ats changed-positions))
       (strmap flip changed-positions) ")"))

(defn changed-positions [width height [[x1 y1] [x2 y2]]] 
    (for [y (range y1 (inc y2)) x (range x1 (inc x2))]
      (position-from-xy [x y] width)))

(defn move-action [width height [[x1 y1] [x2 y2]]] 
  (let [changed-positions (changed-positions width height [[x1 y1] [x2 y2]])]
    (p-action
      (str "move-" (inc x2) "X" (inc y2))
      (move-parameters changed-positions) 
      (move-predicate width height changed-positions) 
      (move-effect changed-positions)))) 

(defn move-actions [width height]
  (filter-str
    (flatten
      (for [x (range width) y (range height)]
          (move-action width height [[0 0] [x y]])))))
      
