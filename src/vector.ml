(* Vecteurs *)

type vector = float list

exception IncompatibleDimensions

let add u v =
  let rec aux acc = function
    | [], [] -> List.rev acc
    | ui::uu, vi::vv -> aux ((ui +. vi)::acc) (uu, vv)
    | _ -> raise IncompatibleDimensions 
  in aux [] (u, v)

let sub u v =
  let rec aux acc = function
    | [], [] -> List.rev acc
    | ui::uu, vi::vv -> aux ((ui -. vi)::acc) (uu, vv)
    | _ -> raise IncompatibleDimensions 
  in aux [] (u, v)

let scale u k = 
  let rec aux acc = function
    | [] -> List.rev acc
    | x::uu -> aux ((x *. k)::acc) uu
  in aux [] u

let dist_man u v =
  let rec aux u v acc = 
    match (u, v) with 
    | [], [] -> acc
    | x::uu, y::vv -> aux uu vv (acc +. abs_float (x -. y))
    | _ -> raise IncompatibleDimensions 
  in aux u v 0.

let dist_euc u v = 
  let rec aux u v acc = 
    match (u, v) with 
    | [], [] -> sqrt acc
    | x::uu, y::vv -> aux uu vv (acc +. (x -. y) *. (x -. y))
    | _ -> raise IncompatibleDimensions 
  in aux u v 0.

let compare u v = 
  Pervasives.compare u v

let random n a b =
  let amp = b -. a in
  let rec aux acc = function
    | 0 -> acc
    | n -> aux ((a +. Random.float amp)::acc) (n - 1)
  in aux [] n

let randomp n a b prec =  
  let amp = b -. a in
  let rec aux acc = function
    | 0 -> acc
    | n ->
      let x = a +. Random.float amp in
      let x = x -. (mod_float x prec) in
      aux (x::acc) (n - 1)
  in aux [] n

let closest u vlist fdist = 
  let rec aux icur imin dmin = function
    | [] -> imin
    | v::ss -> 
      let dcur = fdist u v in
      if dcur < dmin then
        aux (icur + 1) icur dcur ss
      else 
        aux (icur + 1) imin dmin ss
  in aux 0 0 max_float vlist

let print x = begin 
  print_char '[';
  let rec aux = function
    | [] -> ()
    | x::ss -> 
      print_float x;
      print_char ' ';
      aux ss;
  in aux x;
  print_char ']';
end

