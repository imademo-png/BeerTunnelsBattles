unit unitVueVille;
{$codepage utf8}
{$mode objfpc}{$H+}

interface
uses
  unitVueLieu;

//Fonctions et procédures
//Affichage de la ville
function  mainVille() : Lieu;
  
  
implementation
uses
  SysUtils, Classes,unitVueIHM,GestionEcran;
//Affichage de la ville
function  mainVille() : Lieu;
begin
  afficherInterfacePrincipale('Hall principal de la Moria');

  deplacerCurseurXY(29,7);write('Vous vous trouvez dans le hall principal de la Moria. Le lieu est empli du bruit de ses hab');
  deplacerCurseurXY(29,8);write('itants. Partout autour de vous, les gens s''affèrent à leur travail, courant de-ci de-là,');
  deplacerCurseurXY(29,9);write('portant caisses et objets en tous genres.');

  deplacerCurseurXY(29,11);write('Au nord résonne le son des marteaux de la grande forge. On y fabrique probablement de nou');
  deplacerCurseurXY(29,12);write('velles armes et armures à partir des matériaux rapportés par les chasseurs.');

  deplacerCurseurXY(29,14);write('A l''est se trouve les étales des marchands. On y vend toutes sortes d''objets qui pourraient');
  deplacerCurseurXY(29,15);write('vous être utiles pour vos futurs contrats.');

  deplacerCurseurXY(29,17);write('Une forte odeur de viande et de bières émane des cuisines de la taverne située prêt des éta');
  deplacerCurseurXY(29,18);write('les des marchands. Pourquoi ne pas s''y arrêter manger et boire un coup ?');

  deplacerCurseurXY(29,20);write('A l''ouest se trouve la guilde des Thanes dans lesquels se trouve votre chambre.');

  deplacerCurseurXY(29,22);write('Et enfin, au sud, se trouve l''accès aux galeries des mines.');

  couleurTexte(White);
  deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
  deplacerCurseurZoneAction(3);write('     1/ Se rendre à votre chambre');
  deplacerCurseurZoneAction(4);write('     2/ Se rendre aux marchands');
  deplacerCurseurZoneAction(5);write('     3/ Se rendre à la forge'); 
  deplacerCurseurZoneAction(6);write('     4/ Se rendre à la taverne');
  deplacerCurseurZoneAction(7);write('     5/ Se rendre aux mines');

  case choixMenu(1,5) of
       1 : mainVille := CHAMBRE;
       2 : mainVille := MARCHAND;
       3 : mainVille := FORGE;  
       4 : mainVille := TAVERNE;
       5 : mainVille := CONTRAT;
  end;                                                                     
end;
  

  
end.