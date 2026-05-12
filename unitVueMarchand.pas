unit unitVueMarchand;
{$codepage utf8}
{$mode objfpc}{$H+}

interface
uses
  unitVueLieu;

//Fonctions et procédures
//Affichage du marchand
function  mainMarchand(message : string) : Lieu;
  
  
implementation
uses
  SysUtils, Classes,GestionEcran,unitVueIHM,unitMetierInventaire;
//Affichage du marchand
function  mainMarchand(message : string) : Lieu;
var
  choix : integer;
begin
  choix := -1;
  while(choix <> 3) do
  begin
    afficherInterfacePrincipale('Marchand de la Moria');

    deplacerCurseurXY(29,7);write('En poussant la porte du marchand, une cloche tinte, et une forte odeur de poudre noire mêlée');
    deplacerCurseurXY(29,8);write('à celle du houblon vous frappe immédiatement. La pièce est encombrée de caisses en bois, de');
    deplacerCurseurXY(29,9);write('fioles étranges et de sacs remplis de petits objets métalliques. Derrière le comptoir, un');
    deplacerCurseurXY(29,10);write('nain trapu au regard perçant vous fixe d’un air intéressé.');

    deplacerCurseurXY(29,13);couleurTexte(cyan);write('Bienvenue, guerrier !');couleurTexte(white);write(' lance-t-il d''une voix rauque, en balayant la poussière de ses mains');
    deplacerCurseurXY(29,14);write('couvertes de suie.');couleurTexte(cyan);write(' Vous venez chercher de l''équipement pour vos contrats ? J''ai tout ce qu''');
    deplacerCurseurXY(29,15);write('il vous faut, bombes, potions...');couleurTexte(white);

    if(message <> '') then afficherMessageErreur(message);

    couleurTexte(White);
    deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
    deplacerCurseurZoneAction(3);write('     1/ Acheter une potion de soin (100 or)');
    deplacerCurseurZoneAction(4);write('     2/ Acheter une bombe (50 or)');
    deplacerCurseurZoneAction(5);write('     3/ Quitter la boutique');

    choix := ChoixMenu(1,3);
    case choix of
        1..2 : message := acheterObjet(choix);
        3 : mainMarchand := VILLE;  
    end;    
  end;                                                                 
end;
  

  
end.