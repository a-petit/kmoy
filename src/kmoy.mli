(** Module des k-moyennes

   Effectue une spécialisation multi-ensemble
   fonction [perform] centrale au module
   fonctions de visualisation
   fonctions de génération de jeux de données "dummy" pour les tests

*)

open Mset
open Vector

module MSetElement :
  sig
    type t = Vector.vector
    val compare : Vector.vector -> Vector.vector -> int
  end

module MSet :
  sig
    type elt = MSetElement.t
    type t = Mset.Make(MSetElement).t
    val empty: t
    val is_empty: t -> bool
    val add: elt -> t -> t
    val tolist: t -> (elt * int) list
    val fromlist: (elt * int) list -> t
    val random: int -> (unit -> elt) -> t
    val print: t -> (elt -> unit) -> unit
  end
(* Spécialisation du type multi-ensemble *)

type dfun = Vector.vector -> Vector.vector -> float
(** Typage des fonctions de calcul de la distance. *)

val compute: MSet.t -> int -> dfun -> MSet.t list
(** [compute ms k d] Applique l'algorithme des k-moyenne au nuage de points 
   représenté par le multi-ensemble [ms]. [k] partitions sont construites selon 
   la méthode de calcul de la dfun précisé par [d]. *)

type printopt
(** Type abstrait pour la paramétrisation de l'affichage *)

val printopt_create: float -> float -> int -> printopt
(** [printopt_create scope_start scope_end dot_size] *)

val visualize: 
  MSet.t -> int -> dfun -> printopt -> Graphics.color list -> int -> unit
(** [visualize ms k d cl delay] En supposant q'une fênetre de [Graphics] soit 
   ouverte, illustre chacune des étapes du calcul des k-moyennes pour le multi-
   ensemble [ms] selon la méthode de calcul de la dfun [d]. La n-ième 
   partition est dessiné de la n-ième couleur de la liste de couleurs cl. La
   valeur [delay] paramètrise lva vitesse de rafraichissement. *)

val visualize_nth: 
  MSet.t -> int -> dfun -> printopt -> Graphics.color -> int -> unit
(** [perform ms k d c i] Procède à l'affichage de la [i]-ième partition
   découlant du calcul des [k]-moyennes pour le multi-ensemble [ms] selon la 
   dfun [d]. *)

