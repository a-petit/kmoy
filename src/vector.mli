(** Vecteurs réels, de dimmension variable

    Implantation minimale d'une structure de vecteur élaborée en réponse aux 
    besoins du projet. Toute les fonctions récursives sont terminales.
*)

type vector = float list
(* Structure, publique *)

exception IncompatibleDimensions
(* Exception renvoyée lorsque deux vecteurs de dimmension différentes sont
  donnés à une fonction. Il n'est pas possible de faire de l'arithmétique avec 
  deux vecteurs de dimmension différentes ! *)

val add: vector -> vector -> vector
(** Renvoie la somme des deux vecteurs donnés. *)

val sub: vector -> vector -> vector
(** Renvoie la différence des deux vecteurs donnés. *)

val scale: vector -> float -> vector
(** Renvoie la multiplication du vecteur par le scalaire donné *)

val dist_man: vector -> vector -> float
(** Renvoie la distance de manhattan qui sépare les deux vecteurs donnés. *)

val dist_euc: vector -> vector -> float
(** Renvoie la distance de euclidienne qui sépare les deux vecteurs donnés. *)

val compare: vector -> vector -> int
(** [compare v1 v2] Compare les deux éléments selon l'ordre lexicographique. La
  relation est un ordre total. Aussi, la valeur renvoyée est:
  - zero si les éléments [v1] et [v2] sont égaux,
  - une valeur strictement négative si [v1] est plus petit que [v2],
  - une valeur strictement positive si [v1] est plus grand que [v2]. *)

val random: int -> float -> float -> vector
(** [random n min max] Renvoie un vecteur de dimmension [n] dont les 
   composantes générés de façon aléatoires sont minorées par min et majorées 
   par max. *)

val randomp: int -> float -> float -> float -> vector
(** [random_integers n min max prec] Renvoie un vecteur de dimmension [n] dont 
   les composantes générés de façon aléatoires, avec un pas de [prec], sont 
   minorées par min et majorées par max. *)

val closest: vector -> vector list -> (vector -> vector -> float) -> int
(** [closest u vlist fdist] Renvoie l'indice du vecteur de vlist qui est 
 * le plus proche du vecteur u d'après le calcul de la distance par fdist *)

val print: vector -> unit
(** Donne une représentation graphique du vecteur sur la sortie standard. *)


