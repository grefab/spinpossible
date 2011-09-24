(ns net.blankenburg.spinpossible.main
  (:gen-class)
  (:use net.blankenburg.spinpossible.spinpossible))

; Advanced Swap 2 reference problem

(def advanced-swap-2 '(((5 2 3) (6 1 4) (7 8 9)) 4))

(defn -main [& terms]
  (do
    (println (time (apply first-solution advanced-swap-2)))
    (println (time (doall (apply all-solutions advanced-swap-2))))))