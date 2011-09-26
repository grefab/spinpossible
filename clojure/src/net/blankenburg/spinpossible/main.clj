(ns net.blankenburg.spinpossible.main
  (:gen-class)
  (:use net.blankenburg.spinpossible.spinpossible2))

; Advanced Swap 2 reference problem
;(def advanced-swap-2 '(((5 2 3) (6 1 4) (7 8 9)) 4))
(def advanced-swap-2 '(5 [5 2 3 6 1 4 7 8 9] 3 4))

(defn- parse-terms 
  ([times field width depth]
    [times field width depth])
  ([times field width depth disallowed-moves-filter]
    (conj (parse-terms times field width depth) (eval disallowed-moves-filter))))
    

(defn -main [& terms]
  (let 
    [problem 
      (if (seq terms) 
        (apply parse-terms (map read-string terms))
        advanced-swap-2)]
    (do
      (println "Evaluating" (first problem) "times the field" (second problem) "with max. depth" (nth problem 2) 
               (if (= (count problem) 5) (str " and filter function " (last terms))))
      (println "First solution:")
;      (println (time (apply first-solution problem)))
      (dotimes [_ (first problem)] (println (time (first (apply solve (rest problem))))))
      (println "All solutions:")
;      (println (time (doall (apply all-solutions problem)))))))
      (dotimes [_ (first problem)] (time (doseq [solution (apply solve (rest problem))] (println solution)))))))

  
               