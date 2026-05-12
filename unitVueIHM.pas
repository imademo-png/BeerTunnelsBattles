unit unitVueIHM;
{$codepage utf8}
{$mode objfpc}{$H+}

interface
procedure afficherInterfaceEtendue(nomLieu : string);
procedure afficherCadreActionEtendu() ;
//Affiche l'interface principale (les cadres principaux)
//nomLieu : nom du lieu
procedure afficherInterfacePrincipale(nomLieu : string);
//Affiche l'interface principale (les cadres principaux pour écran non split)
//nomLieu : nom du lieu
procedure afficherInterfaceSimple(nomLieu : string);
//Positionne le curseur à la n-ième ligne de la zone d'action
procedure deplacerCurseurZoneAction(numLigne : integer); 
//Renvoie le choix du joueur dès qu'il est entre min et max (compris)
//min : valeur minimale acceptée
//max : valeur maximale acceptée
function ChoixMenu(min,max : integer) : integer;
//Attend que le joueur appuye sur Enter dans la zone de réponse sans tenir compte de la réponse
procedure AttendreEntrer();
//Affiche un message d'erreur
//message : message à afficher
procedure afficherMessageErreur(message : string);
//Affiche un message normal
//message : message à afficher
procedure afficherMessage(message : string);
implementation
uses
  SysUtils, Classes,GestionEcran,unitMetierPersonnage,unitMetierEquipement,unitMetierInventaire;

//Affichage du cadre de réponse
procedure afficherCadreResponse();
begin
  dessinerCadreXY(139,36,145,38,simple,white,black);
  deplacerCurseurXY(142,37);
end;

//Renvoie le choix du joueur dès qu'il est entre min et max (compris)
//min : valeur minimale acceptée
//max : valeur maximale acceptée
function ChoixMenu(min,max : integer) : integer;
var
  aFini : boolean;
begin
  aFini := false;
  while (not aFini) do
  begin
    afficherCadreResponse();
    readln(ChoixMenu);
    aFini := ((ChoixMenu>=min) AND (ChoixMenu <=max));
  end;
end; 

//Attend que le joueur appuye sur Enter dans la zone de réponse sans tenir compte de la réponse
procedure AttendreEntrer();
begin
  afficherCadreResponse();
  readln;
end;   

//Positionne le curseur à la n-ième ligne de la zone d'action
procedure deplacerCurseurZoneAction(numLigne : integer);
begin                
  deplacerCurseurXY(5,30+numLigne);
end;

//Affiche un message normal
//message : message à afficher
procedure afficherMessage(message : string);
begin
  deplacerCurseurXY(104-(length(message)div 2),34);
  couleurTexte(green);
  write(message);
  couleurTexte(White);
end;

//Affiche un message d'erreur
//message : message à afficher
procedure afficherMessageErreur(message : string);
begin
  deplacerCurseurXY(104-(length(message)div 2),34);
  couleurTexte(LightRed);
  write(message);
  couleurTexte(White);
end;

//Affiche le nom du lieu au centre de la boite associée (écran split)
//nomLieu : nom du lieu
procedure afficherLieu(nomLieu : string);
begin
   deplacerCurseurXY(74-(length(nomLieu)div 2),2);
   write(nomLieu);
end;

//Affiche le nom du lieu au centre de la boite associée (écran simple)
//nomLieu : nom du lieu
procedure afficherLieuSimple(nomLieu : string);
begin
   deplacerCurseurXY(99-(length(nomLieu)div 2),2);
   write(nomLieu);
end;

//Affichage du cadre extérieur de l'IHM
procedure afficherCadreExterieur();
begin 
  dessinerCadreXY(1,0,198,39,simple,white,black);
end;

procedure afficherCadreActionEtendu() ;
begin
dessinerCadreXY(1,29,74,39,simple,white,black) ;
dessinerCadreXY(74,35,198,35,simple,white,black) ;
deplacerCurseurXY(74,36) ;write(' ') ;
deplacerCurseurXY(74,37) ;write(' ') ;
deplacerCurseurXY(74,38) ;write(' ') ;
deplacerCurseurXY(74,39) ;write(#196) ;
end ;


//Affichage du cadre d'action
procedure afficherCadreAction();
begin
  dessinerCadreXY(1,29,198,39,simple,white,black);
end;

//Affichage le cadre latéral du personnage
procedure afficherMenuLateralPersonnage();
var
  res : Tressources;
begin
  if(getNomPersonnage() <> '') then
  begin
    dessinerCadreXY(147,0,198,39,simple,white,black);
    dessinerCadreXY(156,0,190,2,simple,white,black);
    dessinerCadreXY(158,1,188,3,simple,white,black);
    deplacerCurseurXY(164,2);Write('FICHE DU PERSONNAGE');

    deplacerCurseurXY(164,5);Write('   -------------   ');

    deplacerCurseurXY(155,7); write('       Nom : ',getNomPersonnage());
    deplacerCurseurXY(155,8); write('     Genre : ',getGenrePersonnage());
    deplacerCurseurXY(155,9); write('    Taille : ',getTaillePersonnage());

    deplacerCurseurXY(164,11);Write('   -------------   ');

    deplacerCurseurXY(155,13); write('     Santé : ',getSanteePersonnageToString());
    deplacerCurseurXY(155,14); write('    Argent : ',quantiteResources(MINOR));


    deplacerCurseurXY(164,16);Write('   -------------   ');

    deplacerCurseurXY(155,18); write('      Arme : ',armeEquipee());
    deplacerCurseurXY(155,19); write('    Casque : ',armureEquipee(CASQUE));
    deplacerCurseurXY(155,20); write('     Torse : ',armureEquipee(TORSE));
    deplacerCurseurXY(155,21); write('     Gants : ',armureEquipee(GANTS));
    deplacerCurseurXY(155,22); write(' Jambières : ',armureEquipee(JAMBIERES));
    deplacerCurseurXY(155,23); write('    Bottes : ',armureEquipee(BOTTES));

    deplacerCurseurXY(164,25);Write('   -------------   ');
    for res:=Low(Tressources) to High(Tressources) do
    begin
        if(res <> MINOR) then
        begin
        deplacerCurseurXY(165-length(resourcesToString(res)),27+ord(res));
        write(resourcesToString(res),' : ',quantiteResources(res));
        end;
    end;
    deplacerCurseurXY(164,28+Ord(High(Tressources)));Write('   -------------   '); 
    deplacerCurseurXY(155,30+Ord(High(Tressources)));Write('   Potions : ',quantiteObjet(POTION));
    deplacerCurseurXY(155,31+Ord(High(Tressources)));Write('    Bombes : ',quantiteObjet(BOMBE));
    deplacerCurseurXY(155,32+Ord(High(Tressources)));Write('      Buff : ',getBonusPersonnageString());
  end;
end;


//Affichage le cadre du lieu dans le cas d'un écran simple
//nomLieu : nom du lieu
procedure afficherCadreLieuEcranSimple(nomLieu : string);
begin   
  dessinerCadreXY(48,0,151,2,simple,white,black);
  dessinerCadreXY(54,1,146,3,simple,white,black);
  afficherLieuSimple(nomLieu);
end;

//Affichage le cadre du lieu dans le cas d'un écran split
//nomLieu : nom du lieu
procedure afficherCadreLieuEcranSplit(nomLieu : string);
begin
  dessinerCadreXY(23,0,125,2,simple,white,black);
  dessinerCadreXY(29,1,119,3,simple,white,black);
  afficherLieu(nomLieu);
end;

procedure afficherInterfaceEtendue(nomLieu : string);
begin
  effacerEcran;  
  //Cadre extérieur
  afficherCadreExterieur();
  //Cadre action
  afficherCadreActionEtendu();
  //Cadre latéral droit
  afficherMenuLateralPersonnage();
  //Cadre Lieu
  afficherCadreLieuEcranSplit(nomLieu);

end;

//Affiche l'interface principale (les cadres principaux pour écran split)
//nomLieu : nom du lieu
procedure afficherInterfacePrincipale(nomLieu : string);
begin
  effacerEcran;  
  //Cadre extérieur
  afficherCadreExterieur();
  //Cadre action
  afficherCadreAction();
  //Cadre latéral droit
  afficherMenuLateralPersonnage();
  //Cadre Lieu
  afficherCadreLieuEcranSplit(nomLieu);
end;
                    
//Affiche l'interface principale (les cadres principaux pour écran non split)
//nomLieu : nom du lieu
procedure afficherInterfaceSimple(nomLieu : string);
begin
  effacerEcran;
  //Cadre extérieur
  afficherCadreExterieur();
  //Cadre action
  afficherCadreAction(); 
  //Cadre Lieu
  afficherCadreLieuEcranSimple(nomLieu);
end;

end.