% Marijn Heule and Valentin Mayer-Eichberger
% Ideas
% \today 


Order Encoding
==============

Task: At most one in $\{x_1 \ldots x_n\}$. 
	
	
Order encoding is in size between log and direct
encoding. It needs $n-1$ variables and has nice effect on branching in sat solving. 



Guiding Search
==============

Define a set of variables 

1) Set of branching variables
2) Set of variables for nogood
	* ideally a nogood should contain all variables from one time point
3) Enforce or recommend a variable ordering
	* Spins from time 0 to final, or backwards or interleaving


Literature
==========

* Sean Weaver: BDD stuff
