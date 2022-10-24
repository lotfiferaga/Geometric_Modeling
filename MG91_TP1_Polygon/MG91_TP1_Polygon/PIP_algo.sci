// ============================================================================
// PIP_algo : Point In Polygon Algorithm 
//
//[pos]=PIP_PointLocalization(XY,PT,eps): localisation du point PT / poly XY
//   pos (position de PT) = SURA, SURS, DANS ou HORS.
//   pour afficher "pos" : stringpos(pos) ou printpos(pos)
//
//[pos]=PIP_Demo(XYcoord,eps,D) : Teste [0,0]/au poly XY avec figure
//
// Version : 27.08.2012
// ============================================================================

SURA=-1
SURS=-2
DANS=1
HORS=0
    
//function [pos]=point_dans_poly(XYcoord,c,PT,eps)
//function [pos]=point_dans_poly(XYcoord,PT,eps)
function [pos]=PIP_PointLocalization(XYcoord,PT,eps)
//=======================================================
//[pos]=PIP_PointLocalization(XY,PT,eps):localisation du point PT / poly XY
// XYcoord(c) = coordonnees du contour du polygone simple
// XYcoord = coordonnees du contour du polygone simple
//           le dernier point = premier (fermeture)
// PT : coordonnees du point a tester
// pos : position de PT = SURA, SURS, DANS, HORS.
  TabDec=[1,2,1,3,1,4,5; ...
          2,1,3,1,1,4,5; ...
          1,3,1,1,1,4,5; ...
          3,1,1,1,1,4,5; ...
          1,1,1,1,1,6,5; ...
          4,4,4,4,6,4,5; ...
          5,5,5,5,5,5,5];
//  if (~exists("eps")) then  eps=%eps; end;
  deff('[i]=suiv(i,n)','if(i+1>n), i=1; else i=i+1; end;')
  deff('[i]=prec(i,n)','if(i-1<1), i=n; else i=i-1; end;')
  //
pos=[];Iint=0; // Iint=[]; par defaut pas d'intersection = 0
  NBint=0; 
//  nbseg=length(c);  iseg0=1;iseg=iseg0;
  nbseg=length(XYcoord)/2;  iseg0=1;iseg=iseg0;
  // EXO : ajouter un commentaire
  // recherche d'un point de depart != 5 pour commencer
//  xy1=XYcoord(c(iseg0),:);        
  xy1=XYcoord(iseg0,:);        
//  [pos1]=classer_point_zone(PT,xy1,[]);
  [pos1]=PIP_classer_point_zone(PT,xy1,eps);
  while ( pos1 == 5 ) ,
    iseg=suiv(iseg,nbseg);
//    xy1=XYcoord(c(iseg),:);        
    xy1=XYcoord(iseg,:);        
//    [pos1]=classer_point_zone(PT,xy1,[]);
    [pos1]=PIP_classer_point_zone(PT,xy1,eps);
    // attention a la boucle infinie (EXO : expliquer le cas)
    if ( iseg == iseg0 ) then pos=HORS; return; end   
  end
  if ( pos1 == 6 ) then pos=SURS; return;  end
  iseg0=iseg; // iseg0 != n'est pas sur la demi-droite
//  while ( iseg <= nbseg )
  while ( %T )
//    printf("iseg=%d\n",iseg);
    iseg=suiv(iseg,nbseg);
//    xy2=XYcoord(c(iseg),:);        
    xy2=XYcoord(iseg,:);        
//    [pos2]=classer_point_zone(PT,xy2,[]);
    [pos2]=PIP_classer_point_zone(PT,xy2,eps);
    dec=TabDec(pos1+1,pos2+1);
  if ( dec == 3 ) then 
   [Iint]=PIP_singulariteSimple(PT,xy1,xy2); // singul. simple
   if ( Iint == -1 ) then pos=SURA; return; end
  end
  if ( dec == 4 ) then  // --- singul. compliquee 
    while ( pos2 == 5 ) ,
      iseg=suiv(iseg,nbseg);
//      xy2=XYcoord(c(iseg),:);        
      xy2=XYcoord(iseg,:);        
//      [pos2]=classer_point_zone(PT,xy2,[]);
      [pos2]=PIP_classer_point_zone(PT,xy2,eps);
      // Plus de boucle infinie (EXO : expliquer le cas)
    end
    // comparaison pos1,pos2 : sortir du while seulement...
    if ( pos2 == 6 ) then pos=SURS; return;  end
    if ( pos2 == 4 ) then pos=SURA; return;  end
    if ( modulo(pos1,2) == modulo(pos2,2) ) then
      Iint=0; // du meme cote
    else
      Iint=1; // 
    end
  end  
  // --- fin singularite compliquee ---
//  select ( TabDec(pos1+1,pos2+1) ),
  select ( dec ),
    // pas d'intersection
 case 1 then Iint=0 ,
 case 2 then Iint=1 ,
   // cas terminaux
 case 5 then  pos=SURS,  // sur sommet
 case 6 then  pos=SURA, // sur segment
 end
 // ---- pour le DEBUG :
 if (( exists("PIP_STEP") & PIP_STEP ) | ( exists("PIP_PLOT") & PIP_PLOT )) then
 segstyle=5
 if ( Iint == 1 ) then segstyle=5; end; // rouge
 if ( Iint == 0 ) then segstyle=2; end; // bleu
 if ( pos == SURA ) then segstyle=3; end; // vert
 if ( pos == SURS ) then segstyle=4; end; // cyan
 plot2d([xy1(:,1),xy2(:,1)],[xy1(:,2),xy2(:,2)],style=segstyle,axesflag=0)
 if ( exists("PIP_STEP") & PIP_STEP ) then
//   printf("%d seg, cas %d : intersection = %d\n",iseg, dec,Iint)
   isegp=prec(iseg,nbseg);
   printf("(%d,%d), cas %s : intersections = %d\n",isegp,iseg, stringdec(dec),Iint)
   pause;
//   plot2d([xy1(:,1),xy2(:,1)],[xy1(:,2),xy2(:,2)],style=2,axesflag=0)
 end
end
 if (( pos == SURS ) | ( pos == SURA)) then return; end; // cyan
 NBint=NBint+ Iint;
// iseg=suiv(iseg,nbseg);
 if ( iseg == iseg0 ) then break; end; // on sort du while
 pos1=pos2; xy1=xy2; // A VERIFIER
// iseg=iseg+1;
 end; // du while
  //
 if ( modulo(NBint,2) == 0 ) then
   pos=HORS; // du meme cote
 else
   pos=DANS; // 
 end
endfunction
  
function [Iint]=PIP_singulariteSimple(PT,xy1,xy2)
  //===========================================
  // Iint=-1 sommet est sur le segment
  // Iint=0  pas d'intersection
  // Iint=1  intersection
  // Mod OS : 14.09.2012
XY=(xy2-xy1); XYPT=PT-xy2;
PRV= XY(1)* XYPT(2)- XY(2)* XYPT(1);
NPRV= XY*XY'; NXYPT=XYPT*XYPT';
eps2=eps*eps*NPRV*NXYPT; PRV2=PRV*PRV;
if ( xy1(1,2) < xy2(1,2) ) then
    Iint=0; if ( PRV > sqrt(eps2) ) then  Iint=1;  end
//    Iint=0; if ( PRV2 > eps2 ) then  Iint=1;  end
else
    Iint=1; if ( PRV > sqrt(eps2) ) then  Iint=0;  end
//    Iint=1; if ( PRV2 > eps2 ) then  Iint=0;  end
end
// si PRV=0 on est SURA
//if (( PRV2 < eps2 )&( PRV2>-eps2 )) then Iint=-1; end;
if ( PRV2 < eps2 ) then Iint=-1; end;
endfunction


function [pos]=PIP_classer_point_zone(PT,ps,eps)
  //===================================
  // classe le point ps par rapport au point PT
  if (isempty(eps)) then eps=%eps; end;
  XPT=PT(1);YPT=PT(2); xps=ps(1); yps=ps(2);
//  if (( yps <= YPT*(1+eps) ) & ( yps >= YPT*(1-eps)) ) then
//  if ( ( abs(yps-YPT) <= abs(yps+YPT)*eps/2) ) then
//    if ( ( abs(xps-XPT) <= abs(xps+XPT)*eps/2) ) then
// EN absolu :
  if ( ( abs(yps-YPT) <= eps/2) ) then
    if ( ( abs(xps-XPT) <= eps/2) ) then
//    if (( xps <= XPT*(1+eps) ) & ( xps >= XPT*(1-eps)) ) then
      pos = 6; // ZONE_6; SUR POINT
      return;
    else
//      if ( xps < XPT*(1+eps) ) then
//      if ( xps < XPT*(1-sign(XPT)*eps) ) then
      if ( xps < XPT-eps/2 ) then
        pos = 4; return ;
      else
        pos = 5; return ;// 
      end
    end
  else
// NOT (( yps < YPT + eps ) & ( yps > YPT - eps) ) 
//    if ( yps <= YPT*(1-eps) ) then
//    if ( yps <= YPT*(1-sign(YPT)*eps) ) then
    if ( yps < YPT-eps/2 ) then
      if ( xps < XPT ) then
        pos= 3; return;
      else
        // xps >= XPT
        pos= 1; return;
      end
    else
      // ( yps >= YPT + eps )
      if ( xps < XPT ) then
        pos= 2; return;
      else
        // xps >= XPT
        pos= 0; return;
      end
    end
  end
endfunction

// ============================= divers TEST & DEMO ============================
function [area]=PIP_PolyArea(XYcoord)
//=========================================
// calcule l'aire du polygone par la methode des trapezes
// convention : positif = matiere a gauche
[nbp,dim]=size(XYcoord)
XY1=[XYcoord;XYcoord($,:)]
XY2=[XYcoord(1,:);XYcoord]
YH=(XY1(:,2)+XY2(:,2))/2
XL=(XY1(:,1)-XY2(:,1))
area=-sum(YH'*XL)
endfunction

function PIP_test_classer_point_zone(eps,nbp)
// --------------------------------------------------
PIP_plotzonesXY00(eps);
PT=[0,0];
XYP=[(rand(2,nbp)-0.5)*10]';
for i=1:nbp
 [pos]=PIP_classer_point_zone(PT,XYP(i,:),eps);
 xstring(XYP(i,1),XYP(i,2),string(pos));
end
endfunction


function [spos]=stringpos(pos)
//========================================
    select(pos)
        case SURA then spos="SURA",
        case SURS then spos="SURS",
        case DANS then spos="DANS",
        case HORS then spos="HORS",
        end
endfunction
function printpos(pos)
//======================================
    printf(stringpos(pos)+"\n");
endfunction

function [sdec]=stringdec(dec)
//=================================================
select(dec)
        case 1 then sdec="PAS D INTERSECTION",
        case 2 then sdec="INTERSECTION SIMPLE",
        case 3 then sdec="SINGULARITE SIMPLE",
        case 4 then sdec="SINGULARITE COMPLIQUEE",
        case 5 then sdec="SUR EXTREMITE",
        case 6 then sdec="SUR SEGMENT",
end
endfunction

function PIP_plotzonesXY00(eps,D)
//---------------------------------
// affiche la decomposition spatiale en zones pour le point 0,0
// A generaliser XY quelconque...
if ( (argn(2)<2) | (isempty(D)))  ,    D=5; end;
XY=[0,0]
// --- figure centree au point ---
plot2d([-D,D],[-eps/2,-eps/2],style=1,axesflag=0,rect=[-D,-D,D,D])
plot2d([-D,D],[eps/2,eps/2],style=1,axesflag=0)
plot2d([0,0],[-D,-eps/2],style=1,axesflag=0)
plot2d([0,0],[D,eps/2],style=1,axesflag=0)
plot2d([eps/2,eps/2],[-eps/2,eps/2],style=1,axesflag=0)
plot2d([-eps/2,-eps/2],[-eps/2,eps/2],style=1,axesflag=0)
// texte dans chaque zone
xstring(D/2,D/2,"zone 0");xstring(D/2,0,"zone 5");
xstring(D/2,-D/2,"zone 1");xstring(-D/2,-D/2,"zone 3");
xstring(-D/2,0,"zone 4");xstring(-D/2,D/2,"zone 2");
endfunction

function PIP_Plot(XYcoord)
//=========================================
    plot2d(XYcoord(:,1),XYcoord(:,2),style=1)
    plot2d(XYcoord(:,1),XYcoord(:,2),style=-3)
    for i=1:(length(XYcoord)/2 -1)
         xstring(XYcoord(i,1),XYcoord(i,2),string(i));
    end
endfunction

function PIP_PlotPointPosition(XYP,Pos)
//=========================================
// Affiche un point avec un symbole qui depend de sa position
ind=find(Pos==DANS);istyle=-4;
if (~isempty(ind)) then plot2d(XYP(ind,1),XYP(ind,2),style=istyle); end
ind=find(Pos==HORS);istyle=-1;
if (~isempty(ind)) then plot2d(XYP(ind,1),XYP(ind,2),style=istyle); end
ind=find(Pos==SURA);istyle=-2;
if (~isempty(ind)) then plot2d(XYP(ind,1),XYP(ind,2),style=istyle); end
ind=find(Pos==SURS);istyle=-3;
if (~isempty(ind)) then plot2d(XYP(ind,1),XYP(ind,2),style=istyle); end
endfunction


//function test_point_dans_poly(XYcoord,eps,D)
function [pos]=PIP_Demo(XYcoord,eps,D)
//------------------------------------------
// PIP_Demo(XYcoord,eps,D) : Teste [0,0]/au poly XYcoord avec figure
PIP_PLOT = %T; PIP_STEP = %T ;
if ((argn(2)<3) | (isempty(D))) then
    Xmax=max(max(XYcoord(:,1)),abs(min(XYcoord(:,1))))
    Ymax=max(max(XYcoord(:,2)),abs(min(XYcoord(:,2))))
    D=1.2*max(Xmax,Ymax); // pour que le polygone soit ds la vue
end
if ((argn(2)<2) | (isempty(eps))) then
    eps=max(max(XYcoord(:,1))-min(XYcoord(:,1)), max(XYcoord(:,2))-min(XYcoord(:,2)))/20
end
XY=[0,0];// le point a tester :
PIP_plotzonesXY00(eps,D); // figure centree au point
PIP_Plot(XYcoord); // nouvelle figure, frontiere seulement
[pos]=PIP_PointLocalization(XYcoord(1:$-1,:),XY,eps); 
printf("Le point est "+stringpos(pos)+" le polygone\n")
endfunction

function [BB,DX,DY]=PIP_BBox(XYcoord)
//=============================================
// [BB]=PIP_BBox(XYcoord) : Calcule la Boite d'encombrement d'un polygone
Xmin=min(XYcoord(:,1));Ymin=min(XYcoord(:,2));
Xmax=max(XYcoord(:,1));Ymax=max(XYcoord(:,2));
BB=[Xmin,Ymin;Xmax,Ymax];
DX=Xmax-Xmin; DY=Ymax-Ymin;
endfunction

function [XYP,Pos]=PIP_testPoints(XYcoord,nbp,eps,modeGP)
//============================================================================
// modeGP : mode de generation des points { ALEAS/GRID }
nbt=nbp; ERR=[];
[nb,dim]=size(XYcoord);
[BoundingBox,DX,DY]=PIP_BBox(XYcoord); // A COPIER ICI ?
XYC=(BoundingBox(2,:)+BoundingBox(1,:))/2
XYD=(BoundingBox(2,:)-BoundingBox(1,:))
nbi=0; i=0; boucle=%T;
// Normaliser le polygone plutot !!!
select(modeGP)
    case "ALEAS"
// ALEAS
    nbt=nbp;
    XYP=(rand(2,nbt)-0.5);
    XYP=XYP'
    XYP(:,1)=XYP(:,1)*XYD(1)+XYC(1);
    XYP(:,2)=XYP(:,2)*XYD(2)+XYC(2);  
    case "GRID"
// GRID
    dl=sqrt((DX*DY)/nbp);
    nx=max(round(DX/dl),1);ny=max(round(DY/dl),1) 
    nbt=nx*ny;
    // X=[0:(nx-1)]*DX/(nx-1);    Y=[0:(ny-1)]*DY/(ny-1);
    // XY=[X,Y']; // A REVOIR POUR FAIRE SANS BOUCLE
    XYP=zeros(nbt,2);
    for i=1:nx
        for j=1:ny
        n=j+ny*(i-1);
        XYP(n,:)=[(i-1)*DX/(nx-1),(j-1)*DY/(ny-1)];
        end
    end
    XYP(:,1)=XYP(:,1)+XYC(1,1)-XYD(1,1)/2;
    XYP(:,2)=XYP(:,2)+XYC(1,2)-XYD(1,2)/2;
end
//    
Pos=zeros(nbt);
for i=1:nbt
  [Pos(i)]=PIP_PointLocalization(XYcoord,XYP(i,:),eps);
end
endfunction

