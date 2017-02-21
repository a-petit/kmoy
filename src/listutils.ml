(* Utilitaires pour les listes *)

let apply_to_nth f l n = 
  if n < 0 then raise (Invalid_argument "apply_to_nth");
  let rec aux acc n = function 
    | e::ll when n = 0 -> List.rev_append ((f e)::acc) ll
    | e::ll when n <> 0 -> aux (e::acc) (n - 1) ll
    | _ -> raise (Failure "nth")
  in aux [] n l

let slice_rev s a b =
  if a < 0 || b < a then raise (Invalid_argument "Listutils.slice");
  let rec aux acc i = function
    | _ when i >= b -> acc
    | x::ss when i >= a -> aux (x::acc) (i + 1) ss
    | _ -> raise (Failure "nth")
  in aux [] 0 s

let slice s a b =
  if a < 0 || b < a then raise (Invalid_argument "Listutils.slice");
  let rec aux acc i = function
    | _ when i >= b -> List.rev acc
    | x::ss when i >= a -> aux (x::acc) (i + 1) ss
    | _ -> raise (Failure "nth")
  in aux [] 0 s
