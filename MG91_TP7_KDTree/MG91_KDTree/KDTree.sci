//==============================================================================
// TP KDTree (Fonctions utiles)
// - OS : 16/10/2015
// Fonctions utiles pour gaenerer et afficher un KDTree de points en 2D
//
//
// plotKDTree(KDT) : affiche le KDT dans la fenetre active
// plotBBox(BBox,couleur): affiche une boite de couleur donne sur la figure courante
// plotPoints(XY) affiche des points avec des lettres associees a leur ordre
// printBinaryTree(T,k) ecrit en texte (sur la console) )un arbre binaire
// [BBox]=BBoxKDTree(KDT,k) Retrouve la boite d'encombrement des points du KDT
// [KDT]=buildKDTree(XY) : Construction du KDTree sur les points de coordonnees "XY" 
// [KDT]=buildKDTree(XY,nbp) : Construction du KDTree dont les feuilles contiennent
//  "nbp" points (ou "nbp"-1)
//
// Chargement : exec("KDTree.sci",-1);
// =============================================================================

function [XY]=data1()
rand("seed",1001); XY= [50*rand(100,1)+10, 26*rand(100,1)+3];
endfunction

function [XY]=data2()
rand("seed",103); XY= [3789.*rand(1000,1)+1450, 8926*rand(1000,1)+678];
endfunction

function [XY]=data3()
rand("seed",51); XY= [0.050*rand(10000,1)+10.4, 0.026*rand(10000,1)+3.55];
endfunction

// EXO, ecrire : function [PointInBox]=findInBox(KDTree,BBox,k)
//===============================================================================

function plotPoints(XY)
// plotPoints(XY) affiche des points avec des lettres associees a leur ordre
    lettres=["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"];
    lettres=[lettres,lettres,lettres,lettres,lettres,lettres,lettres,lettres,lettres,lettres,lettres,lettres,lettres]
    plot2d(XY(:,1),XY(:,2),style=-3);
    xstring(XY(:,1),XY(:,2),lettres(1:length(XY(:,1))));    
endfunction

function printBinaryTree(T,k)
//==============================================================================
// printBinaryTree(T,k) ecrit en texte (sur la console) )un arbre binaire
if ( argn(2) < 2 ) then, k=0; end
n=size(T); i=0;
while ( i < n ) do
        i=i+1;
        if (typeof(T(i))=="string") then, 
            for j=1:int(k), printf("\t"); end;
            printf("%s\n",T(i)); 
            end;
        if (typeof(T(i))=="constant") then, 
            //printf("%f %f\n",T(i)(1),T(i)(2)); 
            if (length(T(i)) == 2) then 
                for j=1:int(k), printf("\t"); end;
                printf("%f %f\n",T(i)(1),T(i)(2)); 
                end;
            if (length(T(i)) == 1) then 
                if ( modulo(k,2)==0 ) then
                  for j=1:int(k), printf("\t"); end;
                  printf("X=%f \n",T(i)(1)); 
                else
                  for j=1:int(k), printf("\t"); end;
                  printf("Y=%f \n",T(i)(1)); 
                end
            end
//            disp(T(i))
        end;
        if (typeof(T(i))== "list") then, printBinaryTree(T(i),k+1); end;
end
endfunction

function [BBox]=BBoxXY(XY)
    BBox=zeros(2,2)
    BBox(1,1)= min(XY(:,1));    BBox(1,2)= min(XY(:,2));
    BBox(2,1)= max(XY(:,1));    BBox(2,2)= max(XY(:,2)); 
endfunction


function [BBox]=BBoxKDTree(KDT,k)
//--------------------------
// [BBox]=BBoxKDTree(KDT,k) Retrouve la boite d'encmobrement des points du KDT
BBox=[];
if ( argn(2) < 3 ) then k=0; end
if (( isempty(KDT))) then return; end;
if (( length(KDT)<=2)) then // c'est un point ou un tableau de points
    P= KDT(1);
    if (typeof(P) == "string") then P=KDT(2); end; // si il y a un label...
    BBox=[min(P(:,1)), min(P(:,2)); max(P(:,1)), max(P(:,2))];    
    return; 
end; // juste les coordonnees
[BBox1]=BBoxKDTree(KDT(2),k+1)
[BBox2]=BBoxKDTree(KDT(3),k+1)
BBox=[min(BBox1(1,1),BBox2(1,1)), min(BBox1(1,2),BBox2(1,2)); ...
      max(BBox1(2,1),BBox2(2,1)), max(BBox1(2,2),BBox2(2,2))];
endfunction

function plotKDTree(KDT,BBox,k)
//--------------------------
// plotKDTree(KDT) : affiche le KDT dans la fenetre active
if ( argn(2) < 3 ) then k=0; end
if ( (k==0) ) then
    if ( argn(2) < 2 ) then 
        // Il faut retrouver la boite :-(
        [BBox]=BBoxKDTree(KDT,k); 
    end
    // scaling de 10%
    plotBBox(BBox,1); // 1=noir
end
dim=2;
//printf("length(KDT)=%0.f\n",length(KDT))
if (( isempty(KDT))) then return; end;
if (( length(KDT)<=2)) then 
//    disp(typeof(KDT),"typeof(KDT)=")
    P= KDT(1);
    if (typeof(P) == "string") then 
        PLabel=P; P=KDT(2); 
        xstring(P(1), P(2),PLabel);    
    end; // si il y a un label...
    plot2d(P(:,1),P(:,2),style=-1); // plusieurs coordonnees
    return; 
end; // juste les coordonnees
pivot=KDT(1); 
if ( modulo(k,dim) == 0) then
    // pivot suivant X
    XL = [pivot;pivot]; YL=BBox(:,2); couleur=5;
//    disp(XL,"XL=")    disp(YL,"YL=")
    plot2d(XL,YL,style=couleur);
    plotKDTree(KDT(2),[BBox(1,1),YL(1);    XL(1),   YL(2)],k+1); // Xmin,XL,...
    plotKDTree(KDT(3),[   XL(1), YL(1);BBox(2,1),   YL(2)],k+1); // XL,Xmax,...
else // pivot suivant Y
    YL = [pivot;pivot]; XL=BBox(:,1); couleur =3;    
    plot2d(XL,YL,style=couleur);
    plotKDTree(KDT(2),[XL(1),BBox(1,2);XL(2),YL(1)],k+1); // X, YL, Ymax,..
    plotKDTree(KDT(3),[XL(1),YL(1);XL(2),BBox(2,2)],k+1); // X, Ymin,YL,...
end
endfunction


function plotBBox(BBox,couleur)
//--------------------------
// plotBBox(BBox,couleur): affiche une boite de couleur donne sur la figure courante
Center=(BBox(2,:)+BBox(1,:))/2;
Diagon=(BBox(2,:)-BBox(1,:));
plot2d(Center(:,1)-0.6*Diagon(:,1),Center(:,2)-0.6*Diagon(:,2),style=0);
plot2d(Center(:,1)+0.6*Diagon(:,1),Center(:,2)+0.6*Diagon(:,2),style=0);
plot2d(BBox(2,1),BBox(2,2))
plot2d([BBox(1,1),BBox(2,1)],[BBox(1,2),BBox(1,2)],style=couleur)
plot2d([BBox(2,1),BBox(2,1)],[BBox(1,2),BBox(2,2)],style=couleur)
plot2d([BBox(2,1),BBox(1,1)],[BBox(2,2),BBox(2,2)],style=couleur)
plot2d([BBox(1,1),BBox(1,1)],[BBox(2,2),BBox(1,2)],style=couleur)
endfunction

function [KDT]=RbuildKDTree(XY,k,iXsort,iYsort)
//--------------------------
// [KDT]=RbuildKDTree(XY,k,iXsort,iYsort) : procedure recursive de construction 
// du KDT, prend en argument :
// iXsort = (sous) liste des points XY tries suivant X
// iYsort = (sous) liste des points XY tries suivant Y
// k profondeur de la recursion
lettres=["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"];
//printf("====> k = %.0f\n",k), disp(lettres(iXsort)),disp(lettres(iYsort))
n=length(iXsort);
if ( n<=nbp_level ) then, KDT=list(XY(iXsort,:)); return; end; // ou la lettre corresp a iXsort ?
ipivot=round((n+1)/2);
//disp(n,"n= "); disp(k,"k= ")
if ( modulo(k,2) == 0) then // decoupage suivant X
    Xpivot=XY(iXsort(ipivot),1) 
    iIXsort=iXsort(1:ipivot-1) 
    iSXsort=iXsort(ipivot:$) // on separe les indices
    // sur l'intervalle X < Xpivot
    [A,B]=intersect(iYsort,iIXsort);  // on veut garder l'ordre de iYsort !!!
    iIYsort=iYsort(gsort(B,"g","i")); // on veut garder l'ordre de iYsort !!!
    k=k+1;
//    printf("k=%.0f\t intervalle inferieur a X=%f\n",k,Xpivot)
    KDT1= RbuildKDTree(XY,k,iIXsort,iIYsort);
    //-----------
    [A,B]=intersect(iYsort,iSXsort);// on veut garder l'ordre de iYsort !!!
    iSYsort=iYsort(gsort(B,"g","i"));
//    printf("k=%0.f\t intervalle superieur ou egal a X=%f\n",k,Xpivot)
    KDT2= RbuildKDTree(XY,k,iSXsort,iSYsort);
//    KDT=list( "x="+string(Xpivot), KDT1, KDT2);
    KDT=list( Xpivot, KDT1, KDT2);
else // decoupage suivant Y
    Ypivot=XY(iYsort(ipivot),2); 
    iIYsort=iYsort(1:ipivot-1); iSYsort=iYsort(ipivot:$); // on separe les indices
    // on conserve le tri sur X
//    printf("k=%.0f\t intervalle inferieur a Y=%f\n",k,Ypivot)
    [A,B]=intersect(iXsort,iIYsort);// on veut garder l'ordre de iXsort !!!
    iIXsort=iXsort(gsort(B,"g","i"));
    k=k+1;
    KDT1= RbuildKDTree(XY,k,iIXsort,iIYsort);
    [A,B]=intersect(iXsort,iSYsort);// on veut garder l'ordre de iXsort !!!
    iSXsort=iXsort(gsort(B,"g","i"));
//    printf("k=%0.f\t intervalle superieur ou egal a Y=%f\n",k,Ypivot)
    KDT2= RbuildKDTree(XY,k,iSXsort,iSYsort);    
//    KDT=list( "y="+string(Ypivot) , KDT1, KDT2);
    KDT=list( Ypivot , KDT1, KDT2);
end
endfunction

function [KDT]=buildKDTree(XY,nbp)
//--------------------------
// [KDT]=buildKDTree(XY) : Construction du KDTree sur les points de coordonnees "XY" 
// [KDT]=buildKDTree(XY,nbp) : Construction du KDTree dont les feuilles contiennent
//  "nbp" points (ou "nbp"-1)
k=0; nbp_level=1; // valeur par defaut
if ( argn(2) == 2 ) then, nbp_level=nbp; end;
[Xsort,iXsort]=gsort(XY(:,1),"g","i");
[Ysort,iYsort]=gsort(XY(:,2),"g","i");
[KDT]=RbuildKDTree(XY,k,iXsort,iYsort);
endfunction
