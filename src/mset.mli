(** Multi-ensemble sur un type totalement ordonné

    Ce module implante la structure de multi-ensemble sur des arbres binaires
    de recherche automatiquement équilibrés (AVL).
    
    La hauteur de chaque sous-arbre est mémorisée en vue d'accélérer 
    le maintiens de l'équilibre. La fonction d'ajout n'est pas récursive 
    terminale. Cependant, la hauteur de l'arbre est logarithmique par rapport 
    à sa taille, la hauteur de pile est ainsi minimale.

    NOTE : pour une implantation complète, ajouter la fonction remove
    accompagnée des les fonctions auxiliaires sous-jacentes. Les fonctions 
    prefixe et postfixe découlant de infixe peuvent également être implantés.

 *)

module type OrderedType =
  sig
    type t
      (** Le type des éléments de MSET. *)

    val compare : t -> t -> int
      (** Une fonction d'ordre total sur les éléments de MSET. *)
  end

module type MSET = 
  sig 
    type elt
    (** Le type des éléments du multi-ensemble. *)

    type t
    (** Le type du multi-ensemble. *)

    val empty: t
    (** L'ensemble vide. *)

    val is_empty: t -> bool
    (** Test si l'ensemble est vide ou non. *)

    val add: elt -> t -> t
    (** [add t x] Renvoie l'arbre constitué de toute les valeurs de [t], 
      plus [x]. Si x est déjà présent dans [t] (selon la fonction l'ordre) 
      alors l'arbre renvoyé est identique à [t]. Non récursive terminale *)

    val tolist: t -> (elt * int) list
    (** Renvoie la liste des valeurs du multi-ensemble sous la forme de
      coupes (élément, quantité). *)

    val fromlist: (elt * int) list -> t
    (** Fonction inverse de [tolist]. *)

    val random: int -> (unit -> elt) -> t
    (** [random n xrand] Renvoie un arbre contenant [n] valeurs aléatoires 
      générées par la fermeture [xrand]. *)

    val print: t -> (elt -> unit) -> unit
    (** [print t xprint] Donne une représentation graphique de l'arbre [t] 
      sur la sortie standard. Les valeurs sont tracés par [xprint]. *)
  end

module Make (Ord : OrderedType) : MSET with type elt = Ord.t
(** Functor qui construit une implantation de la structure de multi-ensemble
  pour un type totalement ordonné passé en argument. *)

