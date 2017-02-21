(* Utilitaires pour les listes *)

val apply_to_nth: ('a -> 'a) -> 'a list -> int -> 'a list
(** [apply_to_nth f [a1; ...; an; ...] n] applique la fonction [f] à 
  l'élément [n], et construit la liste [a1; ...; f an; ...]. Si [n] est 
  négatif, une erreur Invalid_argument "apply_to_nth" est levée, de même, 
  Failure "nth" est levée si [n] est supérieur au cardinal de la liste. *)

val slice: 'a list -> int -> int -> 'a list
(** [slice s begin end] Renvoie une sous liste de s qui contient la suite 
  des éléments de s allant de l'indice begin (inclus) à l'indice end (exclus).
  Une exception Invalid_argument "slice" est levée si [a] < 0 ou [b] < [a]
  et une exception Failure "nth" est levée si la liste [s] est trop courte. *)
