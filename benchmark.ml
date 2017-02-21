(** Programme de test 
  
  Ce programme présente plusieurs exemples d'utilisation allant de l'exemple 
  le plus général à des cas plus spécifiques.
  
    Utilisation

  Lancer ocaml en mode interactif depuis le chemin courant.

  La première section * Initialisation de l'environnement * est requise dans 
  son intégralité. Autrement, chaque section peut être exécuté de façon 
  indépendante. Les paragraphes qui constituent les sections ont été conçus 
  pour être exécuté séquentiellement, de façon exhaustive. Chaque section est 
  délimitée par un blocs de commentaires.
    
    Remarques
  
  Afin de lever toute ambiguité, les fonctions de module sont appelés de façon 
  explicites. La seule esception est faite pour les fonctions de Graphics. Dans 
  l'usage, le préfixe 'Module.' peut être homis dès lors que le module est lié 
  au programme par la directive 'open Module'.

*)

(* Initialisation l'environnement. 
   
   On procède au chargement des bibliothèques kmoy et graphics. Les fichiers
   benchmarkutils et colors apportent les fonctions generate, generatep, 
   des raccourcis pour la visualisation et des fonctions de génération de
   jeux de couleurs. Les module Random est initialisé et une fenêtre graphique
   est ouverte. *)

#use "topfind";;
#require "kmoy";;
open Graphics;;
#use "benchmarkutils.ml";;
#use "colors.ml";;
Random.self_init();;
open_graph " 900x900+50-0";;

(* Rappels / raccourcis *)

open_graph "";;

clear_graph()

close_graph()

(* Exemple rapide sur des données aléatoires normalisés dans le plan.
 
   Paramètres du nuage aléatoire
     n      : nombre de points
     min    : valeur minimale de chaque composante
     max    : valeur maximale de chaque composante
     dim    : dimension du vecteur
   Paramètres de l'algorithme des kmoyennes
     k      : nombre de partitions
     dist   : fonction de distance
   Paramètres d'affichage
     opt    : étendue des valeurs (min, max) et taille des points
     delay  : temporisation entre chaque rafraichissement
     colors : couleur de chaque partition (affichage complet)
     color  : couleur de la partition (affichage sélectif) *)

let n      = 5000
let min    = 0.0
let max    = 1.0
let dim    = 2
let ms     = generate n dim min max
let k      = 3
let dist   = Vector.dist_euc
let dot    = 3
let opt    = Kmoy.printopt_create min max dot
let delay  = 0
let colors = colorset k
let color  = 0x0C94DB

Kmoy.compute ms k dist

kmoy_visualize ms k dist opt colors delay

kmoy_visualize_nth ms k dist opt color 0

kmoy_visualize_nth ms k dist opt color 1

kmoy_visualize_nth ms k dist opt color 2

kmoy_visualize_nth ms k dist opt color 3


(* Exemple usuel : à partir de données de l'utilisateur.
  
  1. Le fichier "values.ml" stock la variable {val uvals : float list list} qui 
  est une liste de vecteurs dont les composantes ont été générés aléatoirement 
  à l'aide du programme c placé dans le dossier outils/. 

  2. On construit le multi-ensemble [ms] associé à [uvals].
                                                
  3. On applique l'algorithme des k-moyennes au nuage de points [ms]

  4. On visualise une simulation

*) 

#use "./outils/values.ml"

let ms = 
  List.fold_left (fun acc x -> Kmoy.MSet.add x acc) Kmoy.MSet.empty uvals

let k      = 5
let dist   = Vector.dist_euc;;
Kmoy.compute ms k dist

let k      = 5
let dist   = Vector.dist_man
let delay  = 0
let colors = colorset k
let opt    = Kmoy.printopt_create 0.0 1.0 2;;
kmoy_visualize ms k dist opt colors delay

(* Exemple général dans un espace quelconque. *)

let n      = 5000
let min    = 0.0
let max    = 1.0
let dim    = 15
let ms     = generate n dim min max

let k      = 8
let dist   = Vector.dist_man;;
Kmoy.compute ms k dist

(* Génération et affichage d'un multi-ensemble. *)

let n      = 50
let min    = 0.0
let max    = 3.0
let dim    = 3
let prec   = 1.0
let ms     = generatep n dim min max prec

Kmoy.MSet.print ms Vector.print


(*******************)
(*** CAS LIMITES ***)

(* Cas A : Fort partitionnage (k grand). *) 

let n      = 20000
let min    = 0.0
let max    = 1.0
let dim    = 2
let k      = 50
let dist   = Vector.dist_euc
let colors = colorset k
let opt    = Kmoy.printopt_create min max 3
let delay  = 0
let ms     = generate n dim min max

kmoy_visualize ms k dist opt colors delay


(* Cas B : Nuage disparate de grande taille : 1 000 000 de vecteurs normalisés 
   avec un pourcentage quasi nul de valeurs identiques. On montre ensuite que
   pour un volume identique de donnée qui est plus homogène, les performances
   sont bien meilleures. *)

let m      = 1000000
let min    = 0.0
let max    = 1.0
let dim    = 2
let k      = 10
let dist   = Vector.dist_man
let colors = colorset k
let opt    = Kmoy.printopt_create min max 2
let delay  = 0
let ms     = generate m dim min max

kmoy_visualize ms k dist opt colors delay

let prec   = 1.0 /. 100.
let ms     = generatep m dim min max prec

kmoy_visualize ms k dist opt colors delay

