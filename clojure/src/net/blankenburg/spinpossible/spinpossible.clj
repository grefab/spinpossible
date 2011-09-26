(ns net.blankenburg.spinpossible.spinpossible)

; Define basic game functions and helpers.
; Playing field (rows) are of the form ((-1 -2 3)(4 5 6)(7 8 9)), wherein negative numbers are "flipped".

(defn- take-from [x n s]
  "Returns the sub-sequence of s starting at element number x and with length n"
  (take n (drop x s)))
 
(defn- subfield [rows x y width height]
  "Takes a playing field with width field-width and given elements, and returns
  a sequence of rows of a sub-field whose upper left corner is given by x and y,
  and with given width and height."
  (take-from y height (map #(take-from x width %) rows)))
 
(defn- move-rows [rows]
  "Executes a move, i.e. rotates the given sub-field and flips its elements."  
  (partition (count (first rows)) (map #(* -1 %) (reverse (flatten rows)))))
 
(defn- replace-in 
  "Replaces elements starting at position x in s with elements from s2.
   The 4-argument form does a 2d-replace starting at position (x,y)
   and calling replace-in for each sub-collection in s with the corresponding one in s2."
  ([s x s2]
    (concat (take x s) s2 (drop (+ x (count s2)) s)))
  ([s x y s2] 
    (replace-in s y (map 
                       #(replace-in %1 x %2) 
                       (take-from y (count s2) s) 
                       s2))))
   
(defn move [rows [x y width height]]
  "Gets the result for the move given by the rectangle [x y width height] on rows."
  (replace-in rows x y (move-rows (subfield rows x y width height))))

(defn correct? [rows width x y]
  "Returns true iff the element at x,y is at the right place and orientation"
  (= (+ (inc x) (* y width)) ; tried using a memoized fn or array, but both are slower
      (nth (nth rows y) x)))

(defn correctness-seq [rows width [x y w h]]
  "Returns a lazy sequence of booleans indicating whether the elements in the given subfield are correct.
   Order is left-to-right top-down."
  (for [yi (range y (+ y h)) xi (range x (+ x w))]
    (correct? rows width xi yi)))

(defn solved? [rows width height]
  "Returns true iff all numbers are in the right position and orientation."
  (every? true? (correctness-seq rows width [0 0 width height])))


; Define the actual solving algorithm and helpers

(defn all-possible-moves [width height]
  "Generates the sequence of all possible moves."
  (apply concat
    (for [x (range width) y (range height)]
      (for [w (range 1 (inc (- width x))) h (range 1 (inc (- height y)))]
          [x y w h]))))
 

(defn- second-last-move [rows width all-moves]
  "In the second-last move, all elements which at the right place and orientation
   must be excluded"
   (filter #(every? not (correctness-seq rows width %)) all-moves))  

(defn- last-move [rows width height]
  "In the last move, all elements that are not at the right place and orientation 
   must be included. All others must be excluded. Here, we just take the bounding
   box of not yet correct elements."
  (let 
    [correctnesses (correctness-seq rows width [0 0 width height]) 
     wrong-xs (map second (filter #(false? (first %)) (partition 2 (interleave correctnesses (flatten (repeat height (range 0 width)))))))
     wrong-ys (map second (filter #(some false? (first %)) (partition 2 (interleave (partition width correctnesses) (range height)))))
     min-x (apply min wrong-xs)
     max-x (apply max wrong-xs)
     min-y (apply min wrong-ys)
     max-y (apply max wrong-ys)]
    [[min-x min-y (inc (- max-x min-x)) (inc (- max-y min-y))]]))
     
(defn make-candidate-filter [rows width last-move]
  "Returns a predicate for candidate moves to indicate whether candidate makes sense in any move."
  (fn [candidate]
    (and 
      (not= candidate last-move)
      ; we assume it never makes sense to move only all-correct elements
      (some false? (correctness-seq rows width candidate)))))    

(defn- make-next-move-params-fn [rows width height disallowed-moves-filter]
  "Gets the rectangles for the next moves depending on depth."
  (let [all-moves (all-possible-moves width height)]
  (fn [rows depth max-depth solution-path]
    (let 
      [remaining-moves (- max-depth depth)
       candidates
         (if (= 2 remaining-moves)
           (second-last-move rows width all-moves)
           (if (= 1 remaining-moves)
             (last-move rows width height)
             all-moves))] ; otherwise, try all possible moves
      (filter disallowed-moves-filter 
        (filter (make-candidate-filter rows width (second (last solution-path))) candidates))))))  

(defn- make-children-fn [rows width height disallowed-moves-filter]
  "Returns a function to be used as the children function in tree-seq; each node is a vector of a 
   playing field, its depth, the max. depth and the solution path (resulting from its parent nodes)."
  (let [next-move-params-fn (make-next-move-params-fn rows width height disallowed-moves-filter)]
    (fn [[rows width height depth max-depth solution-path]]
          (pmap 
            #(vector (move rows %1) width height (inc depth) max-depth (conj solution-path [rows %1])) 
            (next-move-params-fn rows depth max-depth solution-path))))) 

(defn- leaf? [[rows width height depth max-depth solution-path]]
  "A node is a leaf if it has max. depth, the field has been seen before or is a solution."
  (or 
    (= depth max-depth)
    (some #(= rows %) (map first (butlast solution-path)))
    (solved? rows width height))) 

(defn brute-force [rows width height max-depth disallowed-moves-filter]
  "Generates a lazy sequence off possible move sequences with max. depth using tree-seq."
    (tree-seq #(not (leaf? %)) (make-children-fn rows width height disallowed-moves-filter) [rows width height 0 max-depth []]))

(defn all-solutions 
  "Returns a lazy sequence of all solution move sequences."
  ([rows max-depth]
    (all-solutions rows max-depth (constantly true)))
  ([rows max-depth disallowed-moves-filter]
    (let 
      [width (count (first rows))
      height (count rows)]
      (map #(map second %) (map last (filter #(solved? (first %) width height) (brute-force rows width height max-depth disallowed-moves-filter)))))))
    
(defn first-solution 
  "Returns the first found solution move sequence."
  ([rows max-depth]
    (first (all-solutions rows max-depth)))
  ([rows max-depth disallowed-moves-filter]
    (first (all-solutions rows max-depth disallowed-moves-filter))))


