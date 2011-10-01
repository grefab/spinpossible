(ns net.blankenburg.spinpossible.spinpossible2)

(set! *warn-on-reflection* true)

(defn correct? [element position]
  "Checks if the given element is correct at the given position."
  (= (dec element) position))
  
(defn solved? [field width height]
  "Checks if the given field is solved."
  (loop [position (int 0)]
    (if (< position (* width height))
      (if (correct? (nth field position) position)
        (recur (inc position))
        false)
      true)))

(defn xy-from-position [position width height]
  [(mod position width) (quot position height)])

(defn position-from-xy [[x y] width]
  (+ x (* width y)))

(defn- transform-coordinate [coordinate rect-coord1 rect-coord2]
    (- rect-coord2 (- coordinate rect-coord1)))

(defn new-element [position field width height [x1 y1] [x2 y2]]
  "Returns the new element for the given position for the move [x1 y1] [x2 y2] on the given field."
  (let [[x y] (xy-from-position position width height)]
    (if (and (<= x1 x x2) (<= y1 y y2))
      (* -1 (nth field (position-from-xy [(transform-coordinate x x1 x2) (transform-coordinate y y1 y2)] width)))
      (nth field position))))

(defn move [field width height [r1 r2]]
  (loop [position 0 new-field []]
    (if (< position (* width height))
      (recur (inc position) (conj new-field (new-element position field width height r1 r2)))
      new-field)))
        
(defn all-possible-moves [width height]
  "Generates the sequence of all possible moves."
  (apply concat
    (for [x1 (range width) y1 (range height)]
      (for [x2 (range x1 width) y2 (range y1 height)]
          [[x1 y1] [x2 y2]]))))

(defn correctness-seq [field width [[x1 y1] [x2 y2]]]
  "Returns a lazy sequence of booleans indicating whether the elements in the given subfield are correct."
  (for [yi (range y1 (inc y2)) xi (range x1 (inc x2))]
    (let [position (position-from-xy [xi yi] width)] 
      (correct? (nth field position) position))))

(defn in? [[[x11 y11] [x12 y12]] [[x21 y21] [x22 y22]]]
  "Returns true if the first rectangle lies completely inside the second."
  (and (>= x11 x21) (<= x12 x22) (>= y11 y21) (<= y12 y22)))

(defn make-candidate-filter [field width last-move]
  "Returns a predicate for candidate moves to indicate whether candidate makes sense in any move."
  (fn [candidate]
    (or 
      (nil? last-move) 
      (and 
        ; if a move is followed by all-contained moves, it is cumultative with doing the first move last 
        (not (in? candidate last-move))
        ; we assume it never makes sense to move only all-correct elements
        (some false? (correctness-seq field width candidate))))))

(defn- second-last-moves [field width all-moves]
  "In the second-last move, all elements which at the right place and orientation
   must be excluded"
   (filter #(every? not (correctness-seq field width %)) all-moves))

(defn- last-moves [field width height]
  "In the last move, all elements that are not at the right place and orientation 
   must be included. All others must be excluded. Here, we just take the bounding
   box of not yet correct elements."
  (loop [position 0 min-x 9 min-y 9 max-x -1 max-y -1]
    (if (= position (* width height))
      [[[min-x min-y] [max-x max-y]]]
      (if (not (correct? (nth field position) position))
        (let [[x y] (xy-from-position position width height)]
          (recur (inc position) (min min-x x) (min min-y y) (max max-x x) (max max-y y)))
        (recur (inc position) min-x min-y max-x max-y)))))   

(defn get-moves-fn [width height max-depth]
  "Returns a function [ field depth last-move -> moves-sequence ]" 
  (let [all-possible-moves (all-possible-moves width height)]
    (fn [field depth last-move]
      (let [remaining-moves (- max-depth depth)]
      (if (> remaining-moves 2)
        (filter (make-candidate-filter field width last-move) all-possible-moves)
        (if (= remaining-moves 2)
          (second-last-moves field width all-possible-moves)
          (last-moves field width height)))))))

(defn- make-map-fn []
  (let [n (.. Runtime getRuntime availableProcessors)]
    (fn [depth max-depth f s]
      (if (= 4 (- max-depth depth))
        (doall (reduce concat (pmap #(doall (map f %)) (partition n n '() s))))
        (map f s)))))

(defn solve
  "Depth-first search for the solution; parallized only on the first level. A filter function for 
   disallowed elements can optionally be given."
  ([field width max-depth]
    (solve field width max-depth (constantly true)))
  ([field width max-depth disallowed-moves-filter-fn]
  (let 
    [width (int width)
     height (int (/ (count field) width))
     moves-fn (get-moves-fn width height max-depth)
     map-fn (make-map-fn)]
    (letfn 
      [(walk [field depth path seen-fields]
        (lazy-seq
          (cons [field path]
            (if (not (or (solved? field width height) (some #(= field %) seen-fields) (= depth max-depth)))
              (let 
                [new-depth (inc depth)
                 new-seen-fields (conj seen-fields field)]
                (filter 
                  #(solved? (first %) width height) 
                  (apply concat 
                    (map-fn depth max-depth
                      #(walk (move field width height %) new-depth (conj path %) new-seen-fields)
                      (filter disallowed-moves-filter-fn (moves-fn field depth (last path)))))))))))]
      (rest (map second (walk field 0 [] [])))))))

    

     
         