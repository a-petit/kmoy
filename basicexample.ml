(* Exemple pratique et minimal d'utilisation de la librairie. *)

(* Chargement de la bibliothèque des k-moyennes et de la bibliothèque graphique
   pour la visualisation. *)

#use "topfind";;
#require "kmoy";;
open Graphics;;

(* Liste de vecteurs normalisés, ici de dimmension 2. *)

let vals = [
  [0.2; 0.98]; [0.18; 0.68]; [0.64; 0.74]; [0.74; 0.96]; [0.9; 0.38];
  [0.1; 0.62]; [0.4; 0.38]; [0.58; 0.44]; [0.9; 0.6]; [0.8; 0.62];
  [0.7; 0.16]; [0.72; 0.78]; [0.28; 0.1]; [0.16; 0.08]; [0.62; 0.56];
  [0.34; 0.3]; [0.54; 0.]; [0.46; 0.66]; [0.74; 0.2]; [0.08; 0.62];
  [0.06; 0.18]; [0.72; 0.46]; [0.04; 0.8]; [0.4; 0.94]; [0.88; 0.18];
  [0.04; 0.56]; [0.86; 0.76]; [0.34; 0.12]; [0.34; 1.]; [0.2; 0.44];
  [0.54; 0.54]; [0.76; 0.06]; [0.04; 0.7]; [0.2; 0.78]; [0.38; 0.28];
  [0.9; 0.96]; [0.96; 0.6]; [0.4; 0.]; [0.88; 0.28]; [0.42; 0.76]
];

(* Construire le multi-ensemble associé aux données. *)

let ms = List.fold_left (fun acc x -> Kmoy.MSet.add x acc) Kmoy.MSet.empty vals

(* Appliquer l'algorithme des k-moyennes à [ms] pour les paramètres suivants
    k      : nombre de partitions
    dist   : fonction de distance *)

let k      = 5
let dist   = Vector.dist_euc;;
let prts   = Kmoy.compute ms k dist

(* Visualiser le processus de raffinement des partitions effectué par 
   l'algorithme des k-moyennes pour les paramètres suivants 
    k      : nombre de partitions
    dist   : fonction de distance
    delay  : temporisation entre chaque image
    colors : couleur de chaque partition
    scope_min : valeur minimale affichée
    scope_max : valeur maximale affichée
    offset : règle la bordure 
    opt    : étendue des valeurs (min, max) et taille des points
*)

open_graph ""

let k      = 5
let dist   = Vector.dist_euc;;
let delay  = 0
let colors = [16776960; 65280; 65279; 255; 16711934]
let offset = 0.1
let scope_min = 0.0 -. offset
let scope_max = 1.0 +. offset
let opt    = Kmoy.printopt_create scope_min scope_max 4;;
Kmoy.visualize ms k dist opt colors delay

clear_graph()

close_graph()
