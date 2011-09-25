(ns net.blankenburg.spinpossible.main
  (:gen-class)
  (:use net.blankenburg.spinpossible.spinpossible))

; Advanced Swap 2 reference problem
(def advanced-swap-2 '(((5 2 3) (6 1 4) (7 8 9)) 4))

(defn -main [& terms]
  (let 
    [problem 
      (if (seq terms) 
        (read-string (first terms))
        advanced-swap-2)]
    (do
      (println "Evaluating " problem)
      (println "First solution:")
      (println (time (apply first-solution problem)))
      (println "All solutions:")
      (println (time (doall (apply all-solutions problem)))))))