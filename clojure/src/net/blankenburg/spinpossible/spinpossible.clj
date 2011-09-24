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
 
(defn- make-children-fn [rows]
  "Returns a function to be used as the children function in tree-seq; each node is a vector of a 
   playing field, its depth, the max. depth and the solution path (resulting from its parent nodes)."
  (let [subfield-params (subfield-param-sequence (width rows) (height rows))]
    (fn [[rows depth max-depth solution-path]]
      (pmap 
        #(vector (move rows %1) (inc depth) max-depth (conj solution-path %1)) 
        (remove #(= (last solution-path) %) subfield-params))))) ; don't undo the last step

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

