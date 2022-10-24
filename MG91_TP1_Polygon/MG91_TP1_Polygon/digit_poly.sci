// ==========================================================================
// PETIT EDITEUR DE CONTOURS
// OS 04.2012
// OS 10.2020 : modif (supp. xinfo) pour la version 6.2 de scilab 
//   
// DOC : [XY] = DG_DigitPoly()
//     Ouvre une fenetre de digitalisation puis attend la saisie des points
//     jusqu'a la fermeture du polygone simple
//     Aucune verification de coherence n'est realisee
//
//    Chaque clique ajoute un point (et une arete avec le point precedent)
//    Cliquer sur le dernier point ferme le polygone (comme "Entree")
//    "Suppr" permet de supprimer le dernier point saisis.
//
// TODO :
//    Effacer le numero (lors de la suppression)
//    Etendre au polygone non-simplement connexes
//    Etendre a la saisie de 2 polygones (pour union ou intersection...)
//    Recharger et modifier un polygone existant
// ==========================================================================

function [XYcoord] = DG_DigitPoly(BOX,prec)
//===========================================================================
// création d'une fenetre pour la saisie des points
// X: les points du polygone
// Les parametres d'entree sont optionnels
// BOX : dimension de la fenetre de saisie [XYmin;XYmax]
// prec : pas de la grille de saisie (defaut : 1/20 de la boite)
nba=argn(2);
if ( nba<1 ) , BOX=[];end
if ( nba<2 ) , prec=[];end
[ifig,BOX,prec]=DG_fig4Digit([],BOX,prec); // nouvelle fenetre
[XYcoord] = getPoly()
XYcoord=[XYcoord,XYcoord(:,1)]';
endfunction

function [ifig,BOX,prec]=DG_fig4Digit(ifig,BOX,prec)
//===========================================================================
// création d'une fenetre pour la saisie des points
// X: les points du polygone
// Les parametres d'entree sont optionnels
// BOX : dimension de la fenetre de saisie [XYmin;XYmax]
// prec : pas de la grille de saisie (defaut : 1/20 de la boite)
nba=argn(2);
if ( nba<1 ) , ifig=[];end
if ( nba<2 ) , BOX=[];end
if ( nba<3 ) , prec=[];end
if ( isempty(ifig)) then
      f=scf(); 
      ifig=f.figure_id;
  else ; 
      f=scf(ifig); 
end
if ( isempty(BOX)) ,  BOX=[0,0;100,100]; end
if ( isempty(prec)) , prec=min(BOX(2,:)-BOX(1,:))/20, end
//f=figure();  // une nouvelle fenetre
f=figure();  // une nouvelle fenetre
f.background=8;
set(gca(),"auto_clear","off")
//set(gca(),"data_bounds",[0,0;100,100])      // bornes des axes en x et y
set(gca(),"data_bounds",BOX)      // bornes des axes en x et y
set(gca(),"margins",[0.05,0.05,0.05,0.05])  // marges du repere dans la fenetre
set(gca(),"axes_visible",["on","on","on"])  // afficher les axes
set(gca(),"box","on")                       
set(gca(),"auto_scale","off")                       
xgrid;
endfunction

function XYecho(OPERAT,X)
//=============================================================================
// des coordonnees ont ete saisies
// La saisie (en cours rempli le tableau X)
      [dim,i]=size(X);
//      printf("operat=%s\n",OPERAT)
      mess="XY("+string(i)+")="+string(X(1,i))+","+string(X(2,i))
      select (OPERAT)
      case "CREATE" then
          gcf().info_message="Nouveau contour... "+mess;
          // [s,c,v]=MSVC(XY);
          plot(X(1,i),X(2,i),"go"); 
          xstring(X(1,i),X(2,i),string(i));
//      case "NONE" then          break
      case "ADDEDGE" then
          gcf().info_message="Nouvelle arete..."+mess;
          // [e12,v2]=MEV(v1,c,XY);
          plot(X(1,i-1:i),X(2,i-1:i),"g-") ; 
          plot(X(1,i),X(2,i),"go") ;
          xstring(X(1,i),X(2,i),string(i));
      case "CLOSE" then
          gcf().info_message="Fin du contour..."+mess;
          // [f,c2,e12]=MEF(v1,v2,c)
          plot([X(1,i),X(1,1)],[X(2,i),X(2,1)],"g-") ; 
      case "SUPPR"
          gcf().info_message="Suppression du dernier sommet..."+mess;
          //f= ; //fenetre courante
          //bgc=f.background; // pour effacer         
          if ( i > 1 ) then
              plot(X(1,i-1:i),X(2,i-1:i),"w-") ;  // en blanc ...
          end
          plot(X(1,i),X(2,i),"wo") ;
          xstring(X(1,i),X(2,i),"    "); // pour effacer ?
      end
endfunction
  
function [X] = getPoly()
// ============================================================================
// Saisie d'un polygone (etendre a plusieurs)
fin=%F
i = 0;
X=[];
// Saisie d'une polyline...
while ( ~fin )
//  gcf().info_message="Point suivant : bouton gauche - Dernier point : bouton droite";
  [but,v0,v1,iwin,cbmenu] = xclick();
  // iwin = numero de la fenetre
//  printf("but=%d\n",but)
  select (but)
  case 127 then 
      commande="SUPPR"; // SUPPR d'un (du dernier) point
  case 27  then
      commande="ECHAP"; // ECHAP abandon de la commande en cours
  case 10 then
      commande="ENTER"; // FIN de la saisie en cours (polygone?) ????
// tant que presse, click, ou double-click du bouton gauche 
  case 3 then // Le bouton gauche a été cliqué.
      commande="XY"; // XY saisie en cours (polygone)      
  case 0 then // Le bouton gauche a été pressé.
      commande="XY"; // XY saisie en cours (polygone)      
  case 10 then // Le bouton gauche a été double-cliqué.
      commande="XY"; // XY saisie en cours (polygone)      
//  case 20 then // ?
//      commande="XY"; // XY saisie en cours (polygone)      
    else
    commande="unknown";
  end
  //
//  printf("commande=%s\n",commande)
  if ( commande=="XY") then
      // La saisie (en cours rempli le tableau X)
      [X,OPERAT]=getXY2poly(v0,v1,X); // V0,v1 mis ds X
      XYecho(OPERAT,X)
      if ( OPERAT == "CLOSE" ) , fin=%T; end;
  end
  //
  if ( commande=="SUPPR") then
    n=length(X(1,:));
    if (n >0 ) then
      XYecho(commande,X)
      if (n==1) then
         X=[];
      else
         X=X(:,1:$-1);              
      end
    else
      gcf().info_message="Le polygone est vide !!!";
    end
  end
//  if ( commande=="ECHAPP") then
//      Abandon de la polyligne...
//      Fin de la polyligne (mais sans forcement fermer)
  if ( commande=="ENTER") then
      XYecho("CLOSE",X); // mieux vaut fermer pour les polygones
      // Sinon NE PAS FERMER ! Fin de la polyligne !!!!!!
      fin=%T
  end
end;
// on a fini une saisie
endfunction

function [X,OPERAT]=getXY2poly(v0,V1,X)
// ========================================
// La saisie (en cours rempli le tableau X)
// et fait l'echo a l'ecran : point, point + arete
if ( exists("prec") & ~isempty(prec) & (prec>0) ) then
  // on ramene sur une grille de precision PSG
  v0 = round(v0*1/prec)*prec;
  v1 = round(v1*1/prec)*prec;
end
//
[dim,i]=size(X);  i=i+1;
//printf("i=%d\n",i)
OPERAT="CREATE";
if (i>1) then
    // suppression des points doubles ()
    if (( X(1,i-1) == v0 ) & ( X(2,i-1) == v1)) , OPERAT="NONE";return; end;
    // on ferme le polygone
    if (( X(1,1) == v0 ) & ( X(2,1) == v1)) , OPERAT="CLOSE"; return; end;
    OPERAT="ADDEDGE";
end
X(1,i) = v0; X(2,i) = v1;
endfunction

