unit unitVueCreationPerso;
{$codepage utf8}
{$mode objfpc}{$H+}

interface
uses
  unitVueLieu;

//Fonctions et procédures
//Affichage du menu de création de personnage 
function  mainCreationPerso() : Lieu;
  
  
implementation
uses
  SysUtils, Classes,unitVueIHM,GestionEcran,unitMetierPersonnage,unitMetierEquipement,unitMetierInventaire,unitMetierContrat;

//Lance les initialisations de début de partie
procedure InitialisationNouvellePartie();
begin
  initialisationPersonnage();
  initialisationEquipement();
  initialisationInventaire();
  InitialiserContrats();
end;

//Affichage du menu de création de personnage 
function  mainCreationPerso() : Lieu;
var
   nom : string;           //Nom saisi par l'utilisateur
   taille : integer;       //taille saisi par l'utilisateur
   sexe : string;          //sexe du personnage
begin
  InitialisationNouvellePartie();
  unitVueIHM.afficherInterfacePrincipale('Création du personnage');
  deplacerCurseurXY(29,7);write('Voilà plusieurs jours que vous avez quitté Ered Mithrin (les Montagnes Grises), et votre ca');
  deplacerCurseurXY(29,8);write('ravane progresse lentement vers le sud. Partout dans les royaumes nains, on raconte que,');
  deplacerCurseurXY(29,9);write('sous la régence de Durin VI, la Moria regorge d''opportunités pour un nain comme vous en quê');
  deplacerCurseurXY(29,10);write('te de gloire, d''or et de bière.');

  deplacerCurseurXY(29,12);write('On raconte que les prospecteurs de la guilde des mineurs de Khazad-dûm ont découvert de nou');
  deplacerCurseurXY(29,13);write('veaux filons d''or et d''argent, mais surtout de mithril. Cependant, il semblerait que les ga');
  deplacerCurseurXY(29,14);write('leries fraîchement ouvertes soient infestées de mort-vivants, de gobelins et d''autres créa');
  deplacerCurseurXY(29,15);write('tures monstrueuses. Vous avez donc décidé de vous y aventurer, offrant vos talents de guer');
  deplacerCurseurXY(29,16);write('riers en échange de quelques pièces d''or au sein de la guilde des Thanes de Khazad-dûm.');
          

     //Nom du personnage
     couleurTexte(cyan);deplacerCurseurZoneAction(2);write('Comment vous appelez-vous ? ');
     couleurTexte(white);readln(nom);
     setNomPersonnage(nom);
     
     //Taille du personnage
     couleurTexte(cyan);deplacerCurseurZoneAction(4);write('Quelle est votre taille (en cm) ? ');
     couleurTexte(white);readln(taille);
     setTaillePersonnage(taille);

     //Genre du personnage
     couleurTexte(cyan);deplacerCurseurZoneAction(6);write('Etes-vous :   (1) un homme    (2) une femme    (3) autre');
     couleurTexte(white);deplacerCurseurZoneAction(7);
     readln(sexe);
     case sexe of
          '1' : setGenrePersonnage(MASCULIN);
          '2' : setGenrePersonnage(FEMININ);
          else setGenrePersonnage(AUTRE);
     end;

  mainCreationPerso := CHAMBREPREMIEREFOIS;
end;
  

  
end.