// ============================================================================
// Tutorial SCILAB : Une introduction par l'exemple -
//
// Les  exemples ci-dessous  sont donnes en guise  d'introduction a Scilab mais
// seront aussi tres certainement utiles  a ceux qui  connaisse deja  un peu le 
// logiciel.
// Les  questions et  exercices  ne  sont  pas  notes.  Les enonces  des petits 
// EXERCICES  a  la  fin  du  fichiers  sont  a faire  "a  la maison"  a  titre 
// d'entrainement.
// ============================================================================
// ------------------ 1.Les premiers pas
// ----------------------------------------------------------------------------
// "//" sont les commentaires dans le script (idem C++)
// copier les lignes suivantes CTRL ^C, CTRL ^V dans la console :
a=3.5
// la variable "a" prend la valeur 3.5
b=4^2+1; // le ";" supprime l'echo et permet de mettre plusieurs instructions 
// a la suite sur une meme ligne
// la variable b prend la valeur d'une expression arithmetique
// pour consulter le contenu d'une variable :
b
// les variables contiennent par defaut des reels 
// Des "constantes" % et des fonctions elementaires sont predefinies
%e
// booleen : %T = true
if ( %T ) then , printf("c est vrai"); end;
a=%pi/3
d=cos(a)^2+sin(a)^2
sqrt(2)
help cos
// L'aide en ligne est aussi accessible via l'onglet "Application"
//
// ----------------- 2.Vecteurs & matrices
// ----------------------------------------------------------------------------
// 2.1 Definition des vecteurs
// Le separateur est la virgule : ","
V=[1,2,3,4,5]
// la definition peut aussi se faire avec une boucle
for i=1:5
    V(i)=i;
end
V
// ou pour faire plus rapide (dans tous les sens du terme),
// l'affectation directe :
V=1:5
V=5:-1:1
// Question : Interpreter les resultats des 3 lignes suivantes, 
// Sachant que "tic" et "toc" donnent le temps ecoule(en sec), et que "clear" 
// supprime une variable. 
n=100000
clear("V3");tic;V3=1:1:n;duree=toc()
clear("V1");tic;for i=1:n;  V1(i)=i; end; duree=toc()
clear("V2");tic;for i=n:-1:1;  V2(i)=i; end; duree=toc()

// ici le pas=0.5
V=1:0.5:5
// l'affectation peut etre realisee par fonction :
V=rand(1,5)
V=zeros(1,5)
V=ones(1,5)
// vecteur colonne : ";" pour passer a la ligne
V=[1;2;3;4;5]
// le transpose : on retrouve le vecteur ligne
V'
// 2.1 adressage des vecteurs
V(3)
// la derniere valeur (le dernier indice = $ )est affectee a 1
V($)=1
// un intervalle
V(3:5)
// un tableau d'index
V(V)
// Question : que fait la ligne suivante ?
V=V($:-1:1)
// L'egalite entre 2 vecteurs peut etre testee simplement, le resultat est une 
// matrice de booleen :
V(V)==V
// L'egalite entre 2 vecteurs peut s'ecrire en une ligne :
and(V(V)==V)

// 2.2 Les Matrices 
// Les methodes sur les vecteurs s'etendent aux matrices
M=[1:5;6:10;11:15]
M=rand(3,5)*10
[nbl,nbc]=size(M)
// Question : verifier que length(M)=nbl*nbc
M=[1:5;6:10;11:15]
// acces a une cellule de la matrice
M(2,1)
// affectation de la ligne 2 de la matrice
M(2,:)=0
M(2,:)=1:5
// Question : decrire le resultat de l'instruction suivante ?
M(2:$,3)=999
// Question : comparer le resultat des 2 lignes suivantes, expliquer.
M(6,6)
M(6,6)=9
// transposee de la matrice
M'
// --- Operations sur les matrices :
A=[1,2;3,4]; B=[3,3;4,5];
// La multiplication de matrices "*" :
A*B
// alors ".*" est la multiplication terme a terme
A.*B
// la somme :
A+B
// L'ajout d'un scalaire 
a=2
M+a
// Question : decrire ce que font chacune des 3 lignes suivantes ?
M=1:5; sqrt(M*M')
a=2;a^M
M.^2
// Question : ecrire en une instruction les 10 premiers termes d'une suite 
// geometrique de premier terme u0=1 et de raison r=1.1 : u2=r*u1, un=r^n*u0


// ---- resolution du systeme A*X=B  <=> X=A\B  (backslash)
B=[5;11];A=[1,2;3,4]
X=A\B
// on peut verifier que X est solution du systeme
A*X == B
// A*X=B <=> (inv(A)*A)*X=inv(A)*B
X=inv(A)*B

// ------------------ 3. Graphisme 2D (figures) 
// ----------------------------------------------------------------------------
x=(-15:0.1:10);
plot2d(x,5+x^2)
// La fenetre dispose d'un menu et l'on peut entre autre :
// Zoomer/Dezoomer (Outils)
// Effacer la figure (Edit)
// Sauver la figure (*.scg) (Fichier)
// Exporter l'image (PNG, EPS, SVG...) (Fichier)
// Acceder aux attributs graphiques en "Demarrant le selectionneur d'entite" et
// en cliquant sur la courbe par exemple (Edit).
// ...
// Mais toutes ces fonctionnalites sont aussi accessibles via des commandes : 
// Changer une courbe de couleur :
// Pour connaitre les codes des couleurs, cliquer sur la palette fournie par :
getcolor()
// fermer la fenetre pour continuer (Ok ou X)
// Question : Trouver le code de la couleur rouge, definisser la variable "coul"
// et changer le style :
plot2d(x,5+x^2,style=coul)
// style negatif => des symboles en chaque point
plot2d(3,5+3^2,style=-3)
// titre et grille :
xtitle("Hello world","x-axis","y-axis")
xgrid
// pour nettoyer clf = Clear Figure
clf()
// pour creer une nouvelle figure : la numero 12 scf=Set Current Figure
h=scf(12); // la figure devient "courante"
plot2d(x,-50+x^3,style=5)
plot2d(x,-40+(x-1)^3,style=3)
// pour placer une legende : le code 2 = en haut a gauche
legend(["rouge","vert"],2)
// ----------------- 4. IO fichiers
// ----------------------------------------------------------------------------
// La figure peut etre sauvee (sous l'editeur de figure) ou par commande
nomfigure="ma_figure.scg"
xsave(nomfigure,12)
// et rechargee
xload(nomfigure,13); // dans une autre figure

// Pour sauver des donnes (dans un fichier texte):
x=(-15:0.1:10);
XY=[x;-50+x^3]';
nomfic="mes_donnees.txt"
fprintfMat(nomfic,XY); // la sauvegarde se fait dans le repertoire courant
// pwd : print working directory = le repertoire courant
pwd
// Le fichier "nomfic" doit etre present dans le repertoire :
ls
// ou 
dir
// Question : Editer le fichier (c'est du texte) et ajouter des commentaires au debut
// Le chargement se fait de meme :
[XYlu,entete]=fscanfMat(nomfic); // l'entete = texte avant la premiere ligne de nombres
//
// ----------------- 5. recherche, comparaison et tri
// ----------------------------------------------------------------------------
// reprenons l'exemple precedent :
x=(-15:0.1:10); XY=[x;-50+x^3]';
// Recharger le fichier :
[XYlu,entete]=fscanfMat(nomfic); // l'entete = texte avant la premiere ligne de nombres
// Question : Comparer les 5 premieres lignes des tableaux XYlu et XY. 
XYlu(?)
XY(?)
// Question : verifier en une ligne qu'il n'y a PAS egalite entre XYlu & XY
// en utilisant l'operateur "and" :

// "find" permet de trouver les indices (du tableau) qui satisfont la proposition
ind=find((XYlu(:,1)~=XY(:,1)) | (XYlu(:,2)~=XY(:,2)))
// on peut verifier :
// en comparant les X
XYlu(ind(1),1)
XY(ind(1),1)
// et en comparant les Y
XYlu(ind(1),2)
XY(ind(1),2)
// Ils semblent identiques a premiere vue (au format d'impression pres) 
// mais la difference n'est pas nulle bien que proche de la precision %eps
XYlu(ind(1),1)-XY(ind(1),1)
XYlu(ind(1),2)-XY(ind(1),2)
// Conclusion: l'ecriture dans un fichier (ou a l'ecran) est a precision limitee.
// 
// on peut rechercher l'erreur maximale sur Y
[ymax,imax]=max(abs(XYlu(:,2)-XY(:,2)))
// Question : expliquer le resultat de la ligne suivante :
length(find(abs(XYlu(:,2)-XY(:,2))>0 ))/length(XYlu(:,2))
// on peut trier (sort) dans l'ordre des erreurs decroissantes 'd'
[errsort,inderr]=gsort(abs(XYlu(:,2)-XY(:,2)),'g','d');
errsort

// ----------------- 6. scripts et definition de fonctions
// ----------------------------------------------------------------------------
// 6.1 La syntaxe d'une fonction est :  
//    function [param sortie]=nomfonction(param d'entree) 
//    ... 
//    endfunction
// Copier l'exemple ci-dessous dans la console :
function [iter,nmax]=syracuse(n)
// ============================
nmax=n; iter=0;
while ( n ~= 1 )
if ( modulo(n,2)==0 ) then
    printf("%d est pair => n=n/2\n",n);
    pause;
    n=n/2;
else
    printf("%d est impair => n=n*3+1\n",n);
    pause;
    n=n*3+1;
    nmax=max(n,nmax);
end   
iter=iter+1;
end
endfunction
// --- fin de l'exemple

// 6.2 Controle de l'execution d'une fonction
// Appeler la fonction avec les lignes suivantes
[iterations,maxatteint]=syracuse(19)
// A chaque "pause" dans la fonction s'affiche : "-1->"
// L'execution de la fonction est arretee, 
//  Vous pouvez savoir ou elle s'est arretee :
whereami
//  Vous pouvez consulter les variables locales de la fonction
nmax
iter
n
// Vous pouvez continuer l'execution avec :
return
// pour remonter dans l'historique des commandes vous pouvez utiliser la fleche 
// vers le haut

// Vous quittez l'execution avec :
abort
// CTRL ^C interrompt l'execution d'une fonction comme "pause"
// On trouve aussi dans l'onglet "controle" de la console les commandes : 
// reprendre, abandonner, interrompre

// Question : Supprimer les "pause" dans la fonction et recopier le code 
// modifie dans la console. Lancer :
[iterations,maxatteint]=syracuse(195)
[iterations,maxatteint]=syracuse(123999)
[iterations,maxatteint]=syracuse(555222212399943)

// Vous pouvez appeler une fonction sans lire tous ses parametres de sortie :
[iterations,maxatteint]=syracuse(1)
[iterations]=syracuse(1)
// si aucune variable n'est affectee, seule la premiere est affichee
syracuse(1)


// =============================================================================
// EXERCICES : 30m 
// A faire "a la maison" a titre d'entrainement.
// =============================================================================
// EXO 1: tracer un cercle de rayon 5 a l'aide de plot2d. 
// Idee : On utilisera la representation parametrique du cercle pour definir
// un polygone approximant.
//
// EXO 2: appliquer une rotation de pi/3 et une translation (1,2) au point (5,0)
// Verifier graphiquement le resultat.
//
// EXO 3: utiliser la fonction "rand()" pour calculer des points contenus dans 
// un rectangle centrée en 10,20, de longueur 50 et de hauteur 6. 
// Verifier graphiquement le resultat.
//
// EXO 4: calculer le point d'intersection de 2 droites D1 : x+4=0; D2 : 2y+4=0
// en posant le systeme matriciel, et afficher la figure correspondante.
//
// EXO 5: tracer la fonction log(x) sur ]0: 10] avec un pas regulier = 0.5 sur x
// Adapter le pas en x pour ameliorer la representation avec 20 points
// Idee : On definira une suite geometrique pour adapter le pas sur x.
//
