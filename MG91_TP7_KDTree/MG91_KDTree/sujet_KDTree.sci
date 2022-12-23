//==============================================================================
// TP - KDTree
// - OS : 16/10/2015; 03/12/2020; 02/12/2021
// Description d'une structure d'arbre binaire (KDTree) à l'aide de "list"
// Programmation d'un parcours avec recherche des points contenus dans une boite
// Duree : 2h
//==============================================================================
// 1. Visualiser l'image "data/kdtree_1.png" ou directement :
xload("data/kdtree_1.scg");
// et donner le kd-tree correspondant sous la forme d'une liste  :
//        (Xa, (Yb , (), ()), (Yc, (), ()))
// Xa est la valeur de X du pivot (ligne verticale), c'est a dire du point qui 
// definit la mediane de l'ensemble des points. (Yb , (), ()) est le sous arbre 
// gauche, et Yb la valeur du pivot du sous ensemble (ligne horizontale sur la 
// figure)
// -----------------------------------------------------------------------------
// 2. Sous la meme forme, donner le kdtree correspondant aux 5 points suivants :
A=[3,2];B=[4,3];C=[0,2];D=[2,4];E=[1,0];    XY=[A;B;C;D;E];

// pour vous  aider vous pouvez afficher les points et leurs labels sur la figure
Label = ["A","B","C","D","E"]
for i=1:length(XY)/2
    // Affichage d'un texte
    plot2d(XY(i,1),XY(i,2),style=-3)
    xstring(XY(i,1),XY(i,2),Label(i))
end

//
// -----------------------------------------------------------------------------
// 3.En Scilab, un KD-Tree sera représenté avec des listes imbiquées de la forme :
// list(xpivot, list(ypivot_1, list..., list...), list(ypivot_2, list..., list...))))
// ATTENTION chaque point/feuille doit etre dans une liste : list(E), list(A)...
// Charger le fichier suivant pour acceder aux fonctions utiles preprogrammees :
exec("KDTree.sci",-1);
// 3.1 Traduire le kdtree de la question 2 sous cette forme (en "KDT=list(...)")
//
// 3.2 Utiliser les fonctions printBinaryTree(KDT) et plotKDTree(KDT) pour 
//     visualiser votre proposition
//
// 3.3 Comparez votre KDTree avec celui que renvoi la fonction : 
//     [KDT]=buildKDTree(XY);
//
// -----------------------------------------------------------------------------
// 4.Dans cette partie vous programmerez la fonction qui renvoi tous les points 
// du KDT contenus dans une boite qui est donnee par ses 2 points extremaux 
// comme dans l'exemple ci-dessous
Box1=[1,1; 3,3]; 
couleur=2;
plotBBox(Box1,couleur);
// 4.1 Programmer la fonction standard InBox
// Une boite est simplement donnee par ses 2 points extremaux 
function [PointsInBox]=InBox(Box,XY)
//...
endfunction

// 4.2 Programmer la fonction recursive findInBox sur les KDT sur le schema ci-dessous
// On considere que les points sont deja stoques dans le KDT grace a buildKDTree():
[KDT]=buildKDTree(XY);
//
function [PointsInBox]=findInBox(KDTree,Box,k) 
    // La parite de k permet de tester suivant X ou Y
    if ( argn(2) < 3 ) then, k=1; end // l'appel se fait SANS k
    PointsInBox=[];
    if ( isempty(KDTree) ) then, return ([]); end
    if ( length(KDTree)<=2 ) then, // feuille
        // ... a completer
        return; 
    end
    // ...
    if ( //... ) then
    // si la boite se trouve a gauche de l'axe pivot en X 
    // OU si la boite se trouve en dessous de l'axe pivot en Y
    // ... a completer   
        return;
    end
    if ( //... ) then
    // si la boite se trouve a droite de l'axe pivot en X 
    // OU si la boite se trouve au dessus de l'axe pivot en Y
    // ...
        return;
    end
    // sinon il faut visiter les 2 sous arbres
    // ... a completer
endfunction


[PointsInBox]=findInBox(KDT,Box); // Appel pour les tests

// 4.2 Tester votre fonction sur 3 jeux de donnees. Les points sont generee par 
//   des fonctions declarees dans "KDTree.sci" :
XY=data1(); 
XY=data2(); 
XY=data3();
//   Construisez les KDTree correspondant a chacun des cas avec : [KDT]=buildKDTree(XY);
//   Puis tester votre fonction avec les 3 boites suivantes respectivement
Box1=[15,20; 20,30]; 
Box2=[3000,5200; 3400, 5500]; 
Box3=[10.401,3.55;10.402,3.551];
//   Afficher les resultats (les points dans la boite) pour les 2 premiers cas 
//   seulement et sauver les images.

// 4.3 Pour le dernier cas (data3), rechercher directement la solution avec un 
//   test simple de XY.
//
//
// -----------------------------------------------------------------------------
// Au choix (si vous avez encore le temps):
//
// 5. Comparer les temps d'execution de cette recherche (points dans boite) avec
// 5.1 la methode iterative (une boucle "for" sur tous les points)
// 5.2 la methode avec le KDTree (findInBox(KDT,Box) sur chaque points)
// 5.3 la methode "vectorielle" (en une ligne sur le vecteur des points)
// Les mesures (de temps) seront realises avec "tic()" et "dt=toc()" et
// pour les cas precedents data1(), data2() et data3() au minimum.
// Quelles conclusions en tirez-vous ? Proposez une explication.
//
// ou
//
// 5. Gestion du KDTree : nombre de points aux feuilles
//  Le KDTree est construit pour que l'ensemble des points a chaque feuille soit
//  de cardinal 1, mais il peut etre superieur, il suffit d'appeler la fonction 
//  de construction avec un second parametre nbp (le nombre de points aux feuilles)
//  [KDT]=buildKDTree(XY,nbp);
// 5.1 Tester cette possibilité : avec nbp=3 sur un ensemble de 12 points, avec
//    nbp=3 sur un ensemble de 48 points. Afficher les resultats et sauver les 
//    figures.
// 5.2 Verifiez que votre fonction "[]=findInBox(KDT,Box)" fonctionne sur ce type
//    d'arbre, sinon adapter son code.
//
// =============================================================================
