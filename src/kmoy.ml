(* Module des k-moyennes *)

open Graphics

(* Calcule le barycentre de la liste de points pondérés s 
  Une erreur Invalid_argument "bary" est soulevée si la liste est vide. *)

let bary s =
  match s with 
  | [] -> raise (Invalid_argument "bary")
  | (u0, w0)::ss ->
    let rec aux u w = function 
      | [] -> Vector.scale u (1. /. (float_of_int w))
      | (u0, w0)::ss ->
        aux (Vector.add u (Vector.scale u0 (float_of_int w0))) (w + w0) ss
    in aux (Vector.scale u0 (float_of_int w0))  w0 ss

(* Partitionnement les les elts. La méthode renvoie une liste de Card(pvts) 
  partitions (sous forme de listes) qui forment un recouvrement de l'ensemble 
  associé à elts. Chaque élement de elts est placé dans la n-ième partition, 
  où n correspond à l'indice du point de pvts qui est le plus proche de 
  l'élément, d'après la distance mesurée par fdist. *)

let partition elts pvts fdist = 
  let rec aux prts = function 
    | [] -> prts
    | (u, m)::ss ->
      let i = Vector.closest u pvts fdist in
      let p = Listutils.apply_to_nth (fun p -> (u, m)::p) prts i in
      aux p ss
  in aux (List.rev_map (function x -> []) pvts) elts

(* Calcul de la dispersion V *)

let dispersion prts bars fdist = 
  let rec aux prts bars sum = 
    match (prts, bars) with
    | [], [] -> sum
    | p::pp, b::bb -> 
      let f = fun acc (u, m) -> acc +. (float_of_int m) *. (fdist u b) in 
      aux pp bb (sum +. (List.fold_left f 0. p))
    | _ -> raise (Failure "not matching length")
  in aux prts bars 0. 

(* Spécialisation du type multi-ensemble *)

module MSetElement = 
  struct
    type t = Vector.vector
    let compare x y = Vector.compare x y
  end

module MSet = Mset.Make(MSetElement)

type dfun = Vector.vector -> Vector.vector -> float

(* Algorithme des k-moyennes *)
 
let kmoy ms k fdist on_update = 
  let elts = MSet.tolist ms in
  let extr = Listutils.slice elts 0 k in
  let pvts = List.rev_map (fun (u, m) -> u) extr in
  let rec aux pvts lastv = 
    let prts = partition elts pvts fdist in 
    let bars = List.map (function x -> bary x) prts in
    let v = dispersion prts bars fdist in 
    on_update prts;
    print_string "kmoy v : ";
    print_float v;
    print_newline(); 
    if (v >= lastv) then
      prts
    else
      aux bars v
  in aux pvts max_float

(********************************)
(*** Représentation graphique ***)

(* RG - Paramètres constants *)

let color_faded = 0xDDDDDD

(* Structure pour les options d'affichage *)

type printopt = { 
  scope_start : float; 
  scope_end : float; 
  dot_size : int 
}

let printopt_create ss se ds = { 
  scope_start = ss; 
  scope_end = se;
  dot_size = ds;
}

(* Ré-échellone la valeur réelle x par normalisation puis interpolation. *) 

let map x a b m n = m +. ((x -. a) /. (b -. a)) *. (n -. m)

(* Affichage des partitions *)

let draw_partition p c opt =
  set_color c;
  let w = (float_of_int (size_x())) 
  and h = (float_of_int (size_y())) in
  let rec aux = function 
    | [] -> ()
    | ([x; y], m)::pp ->
      let nx = int_of_float (map x opt.scope_start opt.scope_end 0. w) 
      and ny = int_of_float (map y opt.scope_start opt.scope_end 0. h) in
      fill_circle nx ny opt.dot_size;
      aux pp;
    | _ -> raise (Failure "invalid datas")
  in aux p
  
let draw_partitions prts opt colors delay =
  let rec aux i prts colors = 
    match (prts, colors) with
    | [], _ -> ()
    | _, [] -> raise (Failure "not enough colors");
    | p::pp, c::cc -> 
      draw_partition p c opt;
      aux (i + 1) pp cc;
  in aux 0 prts colors;
  let rec tempo = function
    | 0 -> ()
    | n -> tempo (n - 1)
  in tempo delay

let draw_partition_nth prts opt color n = 
  let rec aux i = function
    | [] -> ()
    | p::pp -> 
      let c = if n = i then color else color_faded in
      draw_partition p c opt;
      aux (i + 1) pp;
  in aux 0 prts

(***************************)
(*** Fonctions publiques ***)

let dummy_callback = function x -> ()

(* Calcul des k-moyennes. L'algorithme kmoy casse le multi-ensemble pour
  travailler sur des listes et gagner en efficacité. Les partitions sont 
  renvoyés sous cette même forme de listes. On reconstruit donc les 
  sous-multi-ensembles correspondant pour les renvoyer à l'utilisateur. *)

let compute ms k d =
  let prts = kmoy ms k d dummy_callback in
  let rec aux acc = function
    | [] -> List.rev acc
    | p::pp -> aux ((MSet.fromlist p)::acc) pp
  in aux [] prts

(* Visualisation *)

let visualize ms k d opt cl delay =
  let x = kmoy ms k d (fun prts -> draw_partitions prts opt cl delay) 
  in dummy_callback x

let visualize_nth ms k d opt c n =  
  if n < 0 || n >= k then raise (Invalid_argument "Kmoy.visualize");
  let prts = kmoy ms k d dummy_callback in
  draw_partition_nth prts opt c n

