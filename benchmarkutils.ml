
open Graphics


(* Génération de nuages de points aléatoires. *)

(* Renvoie un nuage de [m] point générés de façon aléatoire. Les points sont 
   des vecteurs réels de dimension [n] dont les composantes sont supérieurs à 
   [min] et inférieurs à [max]. *)

let generate m n min max = 
  let g () = Vector.random n min max in
  Kmoy.MSet.random m g

(* [generatei m n min max prec] Semblable à [generate] mais avec une précision
   fixée à [prec]. *)

let generatep m n min max prec = 
  let g () = Vector.randomp n min max prec in
  Kmoy.MSet.random m g


(* Raccourcis pour la visualisation : nettoyage automatique. *)

let kmoy_visualize ms k dist opt colors delay = 
  clear_graph();
  Kmoy.visualize ms k dist opt colors delay

let kmoy_visualize_nth ms k d opt color pid = 
  clear_graph(); 
  Kmoy.visualize_nth ms k d opt color pid

