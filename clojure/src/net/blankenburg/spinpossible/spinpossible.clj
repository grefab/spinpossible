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

(defn solved? [rows]
  "Returns true iff all numbers are in the right position and orientation."
  (let [flattened-rows (flatten rows)]
    (and
      (every? pos? flattened-rows)
      (= flattened-rows (sort flattened-rows)))))


; Define the actual solving algorithm and helpers

(defn- subfield-param-sequence [width height]
  "Generates the sequence of all possible moves."
  (apply concat
    (for [x (range width) y (range height)]
      (for [w (range 1 (inc (- width x))) h (range 1 (inc (- height y)))]
          [x y w h]))))
 
(defn width [rows]
  "Returns the width of the playing field."
  (count (first rows)))
 
(defn height [rows]
  "Returns the height of the playing field."
  (count rows))

(defn- correct? [rows x y]
  "Returns true iff the element at x,y is at the right place and orientation"
  (= 
    (+ (inc x) (* y (width rows)))
      (nth (nth rows y) x)))

(defn- correctness-seq [rows [x y w h]]
  "Returns a lazy sequence of booleans indicating whether the elements in the given subfield are correct.
   Order is left-to-right top-down."
  (for [yi (range y (+ y h)) xi (range x (+ x w))]
    (correct? rows xi yi)))

(defn- second-last-move [rows all-moves]
  "In the second-last move, all elements which at the right place and orientation
   must be excluded"
   (filter #(every? not (correctness-seq rows %)) all-moves))  

(defn- last-move [rows]
  "In the last move, all elements that are not at the right place and orientation 
   must be included. All others must be excluded. Here, we just take the bounding
   box of not yet correct elements."
  (let 
    [w (width rows) 
     h (height rows)
     correctnesses (correctness-seq rows [0 0 w h]) 
     wrong-xs (map second (filter #(false? (first %)) (partition 2 (interleave correctnesses (flatten (repeat h (range 0 w)))))))
     wrong-ys (map second (filter #(some false? (first %)) (partition 2 (interleave (partition w correctnesses) (range h)))))
     min-x (apply min wrong-xs)
     max-x (apply max wrong-xs)
     min-y (apply min wrong-ys)
     max-y (apply max wrong-ys)]
    [[min-x min-y (inc (- max-x min-x)) (inc (- max-y min-y))]]))
     

(defn- make-next-move-params-fn [rows]
  "Gets the rectangles for the next moves depending on depth."
  (let [all-moves (subfield-param-sequence (width rows) (height rows))]
  (fn [rows depth max-depth solution-path]
    (let 
      [remaining-moves (- max-depth depth)
       candidates
         (if (= 2 remaining-moves)
           (second-last-move rows all-moves)
           (if (= 1 remaining-moves)
             (last-move rows)
             all-moves))] ; otherwise, try all possible moves
      (remove #(= (last solution-path) %) candidates))))) ; never undo the last step
  

(defn- make-children-fn [rows]
  "Returns a function to be used as the children function in tree-seq; each node is a vector of a 
   playing field, its depth, the max. depth and the solution path (resulting from its parent nodes)."
  (let [next-move-params-fn (make-next-move-params-fn rows)]
    (fn [[rows depth max-depth solution-path]]
          (pmap 
            #(vector (move rows %1) (inc depth) max-depth (conj solution-path %1)) 
            (next-move-params-fn rows depth max-depth solution-path))))) 

(defn- leaf? [[rows depth max-depth solution-path]]
  "A node is a leaf if it has max. depth or is a solution."
  (or (= depth max-depth) (solved? rows))) 

(defn brute-force [rows max-depth]
  "Generates a lazy sequence off possible move sequences with max. depth using tree-seq."
  (tree-seq #(not (leaf? %)) (make-children-fn rows) [rows 0 max-depth []]))

(defn all-solutions [rows max-depth]
  "Returns a lazy sequence of all solution move sequences."
  (map last (filter #(solved? (first %)) (brute-force rows max-depth))))
  
(defn first-solution [rows max-depth]
  "Returns the first found solution move sequence."
  (first (all-solutions rows max-depth)))

