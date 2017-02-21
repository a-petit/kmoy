(* Multi-ensemble sur un type totalement ordonné. *)

module type OrderedType = 
  sig
    type t
    val compare: t -> t -> int
  end

module type MSET = 
  sig
    type elt
    type t
    val empty: t
    val is_empty: t -> bool
    val add: elt -> t -> t
    val tolist: t -> (elt * int) list
    val fromlist: (elt * int) list -> t
    val random: int -> (unit -> elt) -> t
    val print: t -> (elt -> unit) -> unit
  end

module Make(Ord: OrderedType) = 
  struct
    type elt = Ord.t

    type t = Empty | Node of t * (elt * int) * t * int

    (* Ensemble vide et test de vacuité. *)

    let empty = Empty

    let is_empty = function 
      | Empty -> true
      | _ -> false

    (* Le multi-ensemble est représenté par un arbre de recherche binaire
      automatiquement équilibré. La hauteur de l'arbre est directement 
      accessible. *)

    let height = function
      | Empty -> 0
      | Node (_, _, _, h) -> h

    (* Constructeur amélioré - avec calcul automatique la hauteur. *)
    
    let create (t0, x, t1) = 
      Node (t0, x, t1, 1 + max (height t0) (height t1))

    (* Calcul l'équilibre de la structure - valeur comprise entre -2 et 2. *)

    let balance = function
      | Empty -> 0
      | Node (t0, _, t1, _) -> (height t0) - (height t1) 

    (* Test si la structure est équilibrée. *)

    let is_balanced t = 
      let rec aux b = function
        | [] -> b | _ when b = false -> b
        | Node (t0, x, t1, h)::mm ->  
          aux (abs (balance (Node (t0, x, t1, h))) <= 1) (t0::t1::mm)
        | Empty::mm -> aux true mm
      in aux true [t] 

    (* Opérations de rotation *)

    let rotation_left = function
      | Node (t0, x0, Node (t1, x1, t2, _), _) -> 
        create (create (t0, x0, t1), x1, t2) 
      | _ -> raise (Invalid_argument "avlt rotation")

    let rotation_right = function
      | Node (Node (t0, x0, t1, _), x1, t2, _) -> 
        create (t0, x0, create (t1, x1, t2))
      | _ -> raise (Invalid_argument "avlt rotation")

    let rotation_left_right = function
      | Node (t0, x, t1, _) -> 
        rotation_right (create (rotation_left t0, x, t1))
      | _ -> raise (Invalid_argument "avlt rotation")

    let rotation_right_left = function
      | Node (t0, x, t1, _) -> 
        rotation_left (create (t0, x, rotation_right t1))
      | _ -> raise (Invalid_argument "avlt rotation")

    (* Rééquilibre la structure si nécessaire *)

    let balancing = function
      | Empty -> Empty
      | Node (t0, _, t1, _) as t ->
        let b = balance t in
        if (abs b) < 2 then
          t
        else 
          if b = 2 then 
            if (balance t0) < 0 then 
              rotation_left_right t
            else 
              rotation_right t
          else
            if (balance t1) > 0 then
              rotation_right_left t
            else 
              rotation_left t

    (* Insertion d'un élément *)
 
    let rec add x = function 
      | Empty -> Node (Empty, (x, 1), Empty, 1)
      | Node (t0, (x0, w0), t1, h) ->
        let c = Ord.compare x x0 in
        if c = 0 then
          Node (t0, (x0, w0 + 1), t1, h)
        else 
          if c < 0 then
            balancing (create (add x t0, (x0, w0), t1))
          else 
            balancing (create (t0, (x0, w0), add x t1))

    (* Conversion en liste *)

    let tolist t =
      let rec aux acc = function
        | [] -> List.rev acc
        | Node (Empty, x, Empty, _)::lt -> aux (x::acc) lt
        | Node (t0, x, t1, _)::lt -> 
          aux acc (t0::(Node (Empty, x, Empty, 1))::t1::lt)
        | Empty::lt -> aux acc lt
        in aux [] [t]

    (* Reconstruction depuis une liste *)

    let fromlist s = 
      let rec aux ms = function
        | [] -> ms
        | (u, m)::ss -> 
          if m < 0 then raise (Failure "negative quantity");
          let rec addrec ms = function
            | 0 -> ms
            | n -> addrec (add u ms) (n - 1)
          in aux (addrec ms m) ss
      in aux Empty s

    (* Génération aléatoire *)

    let random n xrand =
      let rec aux t = function
        | 0 -> t
        | n -> aux (add (xrand()) t) (n - 1)
      in aux Empty n

    (* Afficher n fois le caractère c sur la sortie standard *)

    let rec printnc n c =
      match n with 
      | 0 -> ()
      | n -> print_char c; printnc (n - 1) c

    (* Paramètre d'affichage *)

    let tab = 4

    (* Affichage *)

    let rec print t (xprint : elt -> unit) =
      let rec aux level = function
        | Empty -> 
          printnc (tab * level) ' '; 
          print_char '|';
          print_newline ();
        | Node (t0, (x, m), t1, _) ->
          aux (level + 1) t1;
          printnc (tab * level) ' ';
          xprint x;
          print_string " -- ";
          print_int m;
          print_newline ();
          aux (level + 1) t0;
      in aux 0 t

  end

