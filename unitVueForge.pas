unit unitVueForge;
{$codepage utf8}
{$mode objfpc}{$H+}

interface
uses
  unitVueLieu;

//Fonctions et procédures
//Affichage de la forge
function  mainForge() : Lieu;
  
  
implementation
uses
  SysUtils, Classes,GestionEcran, unitVueIHM,unitMetierEquipement;
function fabricationEquipement(message:string) : lieu;
var
  mat : Tmateriaux;
  arme : TtypeArme;
  armure : TemplacementArmure;
  numeroArme : integer;
  numeroArmure : integer;
  ligneArmure : integer;
  choix : integer;
  nbArmeDiff : integer;
  nbArmureDiff : integer;
begin
  choix := -1;
  nbArmeDiff := ord(High(TtypeArme))-ord(Low(TtypeArme))+1;
  nbArmureDiff := ord(High(TemplacementArmure))-ord(Low(TemplacementArmure))+1;

  while(choix <> 0) do
  begin
    afficherInterfaceEtendue('Forge de la Moria');
    deplacerCurseurXY(63,5);write('Les forgerons vous proposent :'); 

    //Titres des colonnes
    deplacerCurseurXY(4,7);write('--- ARMES ---');
    deplacerCurseurXY(80,7);write('--- ARMURES ---'); 

    //message
    if(message <> '') then afficherMessageErreur(message);

    //Armes
    numeroArme:=1;
    for mat := Low(Tmateriaux) to High(Tmateriaux) do
    begin
      if(mat <> AUCUN) then
      begin
        for arme := Low(TtypeArme) to High(TtypeArme) do
        begin
          couleurTexte(white);
          if(estPossedee(arme,mat)) then
          begin
            couleurTexte(green);
            deplacerCurseurXY(34,8+numeroArme+Ord(mat));write('Déjà possédé(e)');
          end
          else 
          begin
            if(not peutForger(arme,mat)) then couleurTexte(lightred);
            deplacerCurseurXY(34,8+numeroArme+Ord(mat));write(recetteToString(arme,mat)); 
          end;
          deplacerCurseurXY(4,8+numeroArme+Ord(mat));write(numeroArme,'/ ',armeToString(arme,mat));
          numeroArme+=1;
        end;
      end;
    end;

    //Armures
    numeroArmure := numeroArme;
    ligneArmure := 1;
    for mat := Low(Tmateriaux) to High(Tmateriaux) do
    begin
      if(mat <> AUCUN) then
      begin
        for armure := Low(TemplacementArmure) to High(TemplacementArmure) do
        begin
          couleurTexte(white);
          if(estPossedee(armure,mat)) then
          begin
            couleurTexte(green);
            deplacerCurseurXY(110,8+ligneArmure+Ord(mat));write('Déjà possédé(e)');
          end
          else 
          begin
            if(not peutForger(armure,mat)) then couleurTexte(lightred);
            deplacerCurseurXY(110,8+ligneArmure+Ord(mat));write(recetteToString(armure,mat)); 
          end;
          deplacerCurseurXY(80,8+ligneArmure+Ord(mat));write(numeroArmure,'/ ',armureToString(armure,mat));
          numeroArmure+=1;
          ligneArmure+=1;
        end;
      end;
    end;
      



    couleurTexte(white);
    deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
    deplacerCurseurZoneAction(3);write('     ?/ Faire fabriquer une arme (entrer son numéro)');
    deplacerCurseurZoneAction(4);write('     ?/ Faire fabriquer une armure (entrer son numéro)');
    deplacerCurseurZoneAction(6);write('     0/ Retourner au hall principal');   
    
    choix := ChoixMenu(0,numeroArmure-1);
    if(choix = 0) then fabricationEquipement:=VILLE
    else if (choix < numeroArme) then message := forgerArme(TtypeArme((choix-1) mod nbArmeDiff),Tmateriaux((choix-1) div nbArmeDiff+1))
    else message := forgerArmure(TemplacementArmure((choix-numeroArme) mod nbArmureDiff),Tmateriaux((choix-numeroArme) div nbArmureDiff+1));
    
      
  end;
end;

//Affichage de la forge
function  mainForge() : Lieu;
begin
  afficherInterfacePrincipale('Forge de la Moria');
  deplacerCurseurXY(29,7);write('Vous vous faites un chemin à travers l''épaisse fumée qui s''échappe de la forge de la Moria.');
  deplacerCurseurXY(29,8);write('L''air est lourd et il se dégage une forte odeur, mélange de souffre et de fer fondu. A l''o');
  deplacerCurseurXY(29,9);write('deur se rajoutent la chaleur intense des fourneaux et le bruit incessant des marteaux frap'); 
  deplacerCurseurXY(29,10);write('pant le métal.');

  deplacerCurseurXY(29,12);write('C''est ici que la plupart des armures et des armes des Thanes et des mineurs voient le jour.');
  deplacerCurseurXY(29,13);write('Les maitres forgerons peuvent fabriquer l''équipement de votre choix en échange de partie de');
  deplacerCurseurXY(29,14);write('ressources et de quelques pièces.');

  deplacerCurseurXY(29,16);write('A votre arrivée, un nain a la musculature impressionnante se tourne vers vous afin de pren');
  deplacerCurseurXY(29,17);write('dre votre commande.'); 
  
  couleurTexte(White);
  deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
  deplacerCurseurZoneAction(3);write('     1/ Commander une pièce d''équipement');

  deplacerCurseurZoneAction(6);write('     2/ Retourner au hall principal');   
  
  mainForge:=QUITTER;
  case ChoixMenu(1,2) of
    1 : mainForge:=fabricationEquipement('');
    2 : mainForge:=VILLE;
  end;
end;
  

  
end.