unit unitVueMenuPrincipal;
{$codepage utf8}
{$mode objfpc}{$H+}

interface
uses
  unitVueLieu;

//Fonctions et procédures
//Affichage du logo  
function  mainLogo() : Lieu;
  
  
implementation
uses
  SysUtils, Classes,GestionEcran,unitVueIHM,unitVueASCII;

//Affichage du logo  
function  mainLogo() : Lieu;
begin
  afficherLogo();
  deplacerCurseurXY(35,35); Write('1 - Lancer une nouvelle partie');
  deplacerCurseurXY(35,37); Write('2 - Quitter');
  deplacerCurseurXY(35,39); Write('3 - Charger une partie ');
  case ChoixMenu(1,3) of
    1 : mainLogo := CREATIONPERSO;
    2 : mainLogo := QUITTER;
    3 : mainLogo := CHARGER
  end;
end; 
end.