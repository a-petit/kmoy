(* colors : Utilitaire pour la génération de jeu de couleurs. *)

#load "graphics.cma"

open Graphics

(* Constantes *)

let pi = 4.0 *. atan 1.0

(* Interpolation linéaire *)

let lerp t a b = a +. t *. (b -. a)

(* Renvoie la couleur correspondant à l'angle rad (exprimé en radians). *)

let wheel rad = 
  let r = mod_float rad (2. *. pi) in
  let t = mod_float r (pi /. 3.) /. (pi /. 3.) in 
  match r with 
  | _ when r < 1. /. 3. *. pi -> rgb 255 (int_of_float (lerp t 0. 255.)) 0 
  | _ when r < 2. /. 3. *. pi -> rgb (int_of_float (lerp t 255. 0.)) 255 0 
  | _ when r <             pi -> rgb 0 255 (int_of_float (lerp t 0. 255.)) 
  | _ when r < 4. /. 3. *. pi -> rgb 0 (int_of_float (lerp t 255. 0.)) 255 
  | _ when r < 5. /. 3. *. pi -> rgb (int_of_float (lerp t 0. 255.)) 0 255 
  | _                         -> rgb 255 0 (int_of_float (lerp t 255. 0.)) 

(* Renvoie une liste de n coleurs distinctes, linéairement distribués autour
  du cercle chromatique, avec une luminosité et une saturation maximale. *)

let colorset n = 
  if n <= 0 then raise (Invalid_argument "color.disgenerate");
  let rec aux acc = function
    | 0 -> acc
    | i -> 
      let r = (float_of_int i) /. (float_of_int (n+ 1)) *. 2. *. pi in
      aux ((wheel r)::acc) (i - 1)
  in aux [] n

(* Renvoie une liste de n coleurs aléatoires. *)

let colorset_rand n = 
  if n <= 0 then raise (Invalid_argument "color.rangenerate");
  let rec aux acc = function
    | 0 -> acc
    | n -> aux ((Random.int 0xFFFFFF)::acc) (n - 1)
  in aux [] n
  
