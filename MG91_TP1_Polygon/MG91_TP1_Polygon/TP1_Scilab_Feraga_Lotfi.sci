// ============================================================================
// TP1 : polygones (Brep) 
//             Localisation d'un point par rapport a des polygones
// Duree : 1h30
// Version : 2018
// Ressources :
// Les scripts : a charger avec exec("nomfichier.sci",-1)
//    Un outil de digitalisation est donnee dans le fichier "digit_poly.sci"
//    L'algorithme "point_dans_poly" est dans le fichier "PIP_algo.sci"
// Les donnees : 
//    fichiers sous data/*.txt a charger avec M=fscanfMat("nomfichier.txt")
// Les figures : 
//    fichiers sous figures/*.scg a charger avec xload("nomfichier.scg",numfig)
//    ou a l'aide de "Charger" dans le menu "Fichier" de l'editeur de figures.
// ============================================================================
//
// Si vous eprouvez des difficultes n'hesitez pas a faire d'abord le tutorial ou
// TP d'introduction... 
//
// ============================================================================
// 1. Manipulation de polygones (15min)
// ----------------------------------------------
// Manipulation d'une structure de donnees pour les Polygones Simplement Connexes 
// 1.1 Charger des polygones et les afficher a l'aide de differentes fonctions.
//    Charger des polygones "data/polygone_1.txt" et "data/polygone_2.txt"
//    avec "fscanfMat()" puis Afficher les polygones avec "plot2d", et "xfpoly()".
//    A titre de rappel :
[XYPoly1,entete]=fscanfMat("data/polygone_1.txt"); 
plot2d(XYPoly1(:,1),XYPoly1(:,2),style=5) // contour (positif) en rouge
xfpoly(XYPoly1(:,1),XYPoly1(:,2),5)// remplissage en couleur rouge
plot2d(XYPoly1(:,1),XYPoly1(:,2),style=-2) // points (negatif) en croix

//chargement des polygones demandés
[XYPoly1,entete]=fscanfMat("data/polygone_1.txt"); 
plot2d(XYPoly1(:,1),XYPoly1(:,2),style=5) // contour (positif) en rouge
xfpoly(XYPoly1(:,1),XYPoly1(:,2),5)
plot2d(XYPoly1(:,1),XYPoly1(:,2),style=-2)

[XYPoly2,entete]=fscanfMat("data/polygone_2.txt"); 
plot2d(XYPoly2(:,1),XYPoly2(:,2),style=5) 
xfpoly(XYPoly2(:,1),XYPoly2(:,2),5)
plot2d(XYPoly2(:,1),XYPoly2(:,2),style=-2)

// 1.2 Donner "a la main" (dans la console)les coordonnees d'un polygone, par 
// exemple :    MyPoly=[1,2;1,3;...;1,2]; 
//    Il doit etre simplement connexe et avoir 7 cotes (au moins). L'afficher. 
//    De meme, generer un cercle a l'aide des fonction cos() et sin() de n=36
//    cotes.
//    Vous sauverez les figures avec "Exporter vers..." dans la fenetre d'affi-
//    chage ou dans la console avec la commande "xs2png()"
// REPONSE
MyPoly=[1,2;1,3;3,5;4,5;6,4;9,2;1,2];
plot2d(MyPoly(:,1),MyPoly(:,2),style=5)
xfpoly(MyPoly(:,1),MyPoly(:,2),5)
plot2d(MyPoly(:,1),MyPoly(:,2),style=-2)

cercle=zeros(36,2)
for i=1:36
va = i*(2*%pi/36)
cercle(i,1) = cos(va)
cercle(i,2) = sin(va)
end

plot2d(cercle(:,1),cercle(:,2),style=5)
xfpoly(cercle(:,1),cercle(:,2),5)
plot2d(cercle(:,1),cercle(:,2),style=-2)

// 1.3 Digitalisation
//    Charger les scripts de "digit_poly.sci" avec : exec("digit_poly.sci",-1)
//    Digitaliser 3 polygones avec : [XYcoord] = DG_DigitPoly()
//    Que vous sauverez avec fprintfMat() dans des fichiers numerotes de 1 a 3
//
[XYcoord1] = DG_DigitPoly()
fprintfMat("data/polygonedigi1.txt",XYcoord1)
fprintfMat("data/polygonedigi2.txt",XYcoord1)
fprintfMat("data/polygonedigi3.txt",XYcoord1)
// 1.4 Programmer l'algorithme qui calcule de l'aire d'un polygone par la methode
// de votre choix.
// calcule de l'aire 
sum =0
for i=1:7
    for j=1:4
        X= MyPoly[j]
        Y= MyPoly[j+4]
    end
    sum = sum +(1/2)*cross(X,Y)
end

// 1.5 Tester la fonction suivante sur quelques polygones. Que fait-elle ?
function [XYBox]=BBox(XYPoly)
  XYBox = [ min(XYPoly(:,1)), min(XYPoly(:,2));  max(XYPoly(:,1)), max(XYPoly(:,2)) ];
endfunction
// Cette fonction nous donne les coordonnées de la bounding box qui entour le polygone
 

// ============================================================================
// 2. Test de la fonction point_dans_poly (1h15min)
// ----------------------------------------------
// Charger les scripts de "PIP_algo.sci" contenant l'algorithme (avec "exec()")
// 2.0 Lancer la demo "PIP_Demo(XYcoord)" sur les coordonnees des polygones 1 et 2.
//     Les aretes sont testees une par une; tapez "return" pour passer a la suivante.
//     Relancer enfin sur le polygone 2 que vous translaterez du vecteur (-1,-4). 
//     Expliquer avec precision ce que fait la fonction "PIP_Demo".
//     Utiliser "PIP_Demo" pour tester tous les cas pathologiques (presentes dans
//     le cours).
//     Illustrer vos resultats (les figures correspondant aux cas pathologiques).
//
// 2.1 La fonction PIP_PointLocalization permet de localiser un point par rapport
//     a un polygone. Elle se trouve dans le fichier "PIP_algo.sci" :
//     [pos]=PIP_PointLocalization(XYcoord,PT,eps)
//     avec pos=-1 (SURA), pos=-2 (SURS), pos=1 (DANS) et pos=0 (HORS)
//          XYcoord : les coordonnees du polygone
//          eps : la precision des tests ("epaisseur de la 1/2 droite")
//
//     a)Ecrire une fonction qui teste des points aleatoires par rapport a un 
//       polygone donne (en appelant PIP_PointLocalization et la fonction de
//       Scilab : "rand()"). ATTENTION, il faudra que tous les points soient 
//       generes dans la boite d'encombrement du polygone. 
//       Justifier les resultats avec une figure ou les points exterieurs seront
//       affiches avec une croix et les points interieurs avec un losange noir.
//
//       La fonction pourrait prendre la forme suivante :
//
function []=DrawPointsInPoly(XYPoly,nb_Points)
[XYBox]=BBox(XYPoly)
//       ...
for i=1:nb_Points
//    
[pos]=PIP_PointLocalization(XYPoly,PT,eps)
if ( pos < 0 ) then
    plot2d(...,style=-1) // pour la croix
else
    plot2d(...,style=-4) // pour le losange noir   
end
end // du for
endfunction
//
//     b)Charger la figure "point_dans_poly_a_discuter.scg" 
xload("figures/point_dans_poly_a_discuter.scg",13); // ou lire le .png correspondant
//       Elle a ete generee avec une fonction comparable a celle de la question (a) : 
//       Preciser et commenter le resultat. 
//       Quelle valeur a ete utilisee pour "eps" ? 
//       Donner l'intervalle des valeurs possibles.
//
// 2.2 Utiliser la fonction "PIP_PointLocalization" pour estimer l'aire des 
//     polygones (Adapter la fonction du 2.1.a) a partir du % de points a l'interieur
//     du polygone et de l'aire de la boite renvoyee par BBox().
//
// 2.3 Comparer au calcul exact sur le cas particulier de l etoile :
//     Charger le polygone "polygone_7.txt" 
[XYPoly7,entete]=fscanfMat("data/polygone_7.txt"); 
//
//     Verifier que son aire=14.695 par un calcul analytique ou en utilisant un
//     programme de calcul d'aire.
//
//     Estimer le nombre de points necessaire pour une approximation a 10%
//     Comparer vos resultats a ceux de la figure "erreur_estimation_aire.scg"
xload("figures/erreur_estimation_aire.scg",14); // ou lire le .png correspondant
//     Conclure
//
//
// ============================================================================
// 3. D'autres donnees sont fournies sous data : les contours des iles des 
//    cyclades (Grece), le contour de la France métropolitaine... que vous
//    pouvez utiliser pour tester vos programmes...
ls("data/*.txt")
// Par exemple, charger la France et localiser la rade de Brest
[XYPoly1,entete]=fscanfMat("data/Limites_France.txt"); 
xfpoly(XYPoly1(:,1),XYPoly1(:,2),5)// remplissage en couleur rouge

// ============================================================================

