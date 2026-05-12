unit unitVueChambre;
{$codepage utf8}
{$mode objfpc}{$H+}

interface
uses
  unitVueLieu;

//Fonctions et procédures
//Affichage de la chambre la première fois
function mainChambrePremiereFois() : Lieu;
//Affichage de la chambre
function  mainChambre() : Lieu;
  
  
implementation
uses
  SysUtils, Classes,GestionEcran,unitVueIHM,unitVueASCII,unitMetierPersonnage,unitMetierEquipement,unitMetierInventaire;


var
FileVar: TextFile;


//Fonction exécutée lors du repos
//Renvoie le prochain lieu à visiter
function repos() : Lieu;
begin
    dormir();
    afficherInterfacePrincipale('Dans votre lit');
    afficherSleep();   
    AttendreEntrer();
    repos := CHAMBRE;
end;

//Affichage du coffre
function coffreChambre(message : string) : Lieu;
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
    afficherInterfaceEtendue('Votre coffre');
    deplacerCurseurXY(66,5);write('Contenu de votre coffre'); 

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
          if(estEquipee(arme,mat)) then
          begin
            couleurTexte(green);
            deplacerCurseurXY(34,8+numeroArme+Ord(mat));write('Equipée');
          end
          else if(not estPossedee(arme,mat)) then 
          begin
            couleurTexte(LightRed);
            deplacerCurseurXY(34,8+numeroArme+Ord(mat));write('Non possédée');
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
          if(estEquipee(armure,mat)) then
          begin
            couleurTexte(green);
            deplacerCurseurXY(110,8+ligneArmure+Ord(mat));write('Equipée');
          end
          else if(not estPossedee(armure,mat)) then 
          begin
            couleurTexte(LightRed);
            deplacerCurseurXY(110,8+ligneArmure+Ord(mat));write('Non possédée');
          end;
          deplacerCurseurXY(80,8+ligneArmure+Ord(mat));write(numeroArmure,'/ ',armureToString(armure,mat));
          numeroArmure+=1;
          ligneArmure+=1;
        end;
      end;
    end;
      



    couleurTexte(white);
    deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
    deplacerCurseurZoneAction(3);write('     ?/ Equiper une arme (entrer son numéro)');
    deplacerCurseurZoneAction(4);write('     ?/ Equiper une armure (entrer son numéro)');
    deplacerCurseurZoneAction(6);write('     0/ Retourner au hall principal');   
    
    choix := ChoixMenu(0,numeroArmure-1);
    if(choix = 0) then coffreChambre:=CHAMBRE
    else if (choix < numeroArme) then message := Equiper(TtypeArme((choix-1) mod nbArmeDiff),Tmateriaux((choix-1) div nbArmeDiff+1))
    else message := Equiper(TemplacementArmure((choix-numeroArme) mod nbArmureDiff),Tmateriaux((choix-numeroArme) div nbArmureDiff+1));
    
      
  end;
end;

//Affichage de la chambre la première fois
function mainChambrePremiereFois() : Lieu;
begin    

 WriteLn('Test de fichier');
  AssignFile(FileVar, 'Sauvegarde.txt'); // 
  {$I+} //Utilise les exceptions
  try  



    Rewrite(FileVar);  // On crée le fichier qui va receullir les données du personnage dans un fichier txt
    Writeln(FileVar,'Nom : ',getNomPersonnage);
    Writeln(FileVar,'Taille : ',getTaillePersonnageInt);
    Writeln(FileVar,'Genre : ',getGenrePersonnage);
    Writeln(FileVar,'Sante : ',getSanteePersonnage);
    Writeln(FileVar,'Argent : ',quantiteResources(MINOR));
    Writeln(FileVar,'Sante Max : ',getSanteeMaxPersonnage);
    Writeln(FileVar,'cuivre : ',quantiteResources(MINCUIVRE));
    Writeln(FileVar,'Fer : ',quantiteResources(MINFER));
    Writeln(FileVar,'Charbon : ',quantiteResources(MINCHARBON));
    Writeln(FileVar,'Mithril : ',quantiteResources(MINMITHRIL));
    Writeln(FileVar,'Potions : ',quantiteObjet(POTION));
    Writeln(FileVar,'Bombes : ',quantiteObjet(BOMBE));
    Writeln(FileVar,'Buff : ',getBonusPersonnage());
    




    
    CloseFile(FileVar);
  except
    on E: EInOutError do
end;




  afficherInterfacePrincipale('Une chambre dans la guilde des Thanes');  

  deplacerCurseurXY(29,7);write('À votre arrivée à Khazad-dûm, vous vous dirigez vers la guilde des Thanes. Une fois enrolée');
  deplacerCurseurXY(29,8);write(', un membre de la guilde vous conduit à une chambre qui sera la vôtre pendant tout votre sé');
  deplacerCurseurXY(29,9);write('jour ici.');

  deplacerCurseurXY(29,11);write('Vous entrez dans la pièce et jetez un regard autour de vous. La chambre est relativement');
  deplacerCurseurXY(29,12);write('sombre, mais un feu crépitant dans la cheminée diffuse une lumière chaleureuse.');

  deplacerCurseurXY(29,14);write('Les murs sont ornés de tableaux et de têtes de monstres empaillées. Sur la porte, vous rem');
  deplacerCurseurXY(29,15);write('arquez les armoiries de la maison Durin. Le membre de la guilde se tourne vers vous et dé');
  deplacerCurseurXY(29,16);write('clare :');

  couleurTexte(Cyan);
  deplacerCurseurXY(29,18);write('"Voici votre chambre ! Dépêchez-vous de vous installer, les mineurs ont besoin de nous. Des');
  deplacerCurseurXY(29,19);write('contrats vous attendent déjà sur le panneau près de la taverne. Vous trouverez un équipement');
  deplacerCurseurXY(29,20);write('de base dans le coffre là-bas. Si vous voulez mieux, rendez-vous à la forge ou chez le mar');
  deplacerCurseurXY(29,21);write('chand."');

  couleurTexte(White);
  deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
  deplacerCurseurZoneAction(3);write('     1/ Vous reposer dans votre lit');
  deplacerCurseurZoneAction(4);write('     2/ Regarder dans votre coffre');
  deplacerCurseurZoneAction(5);write('     3/ Sortir de votre chambre');
  deplacerCurseurZoneAction(6);write('     4/ Aller à la Taverne');
  mainChambrePremiereFois:=QUITTER;
  case ChoixMenu(1,4) of
    1 : mainChambrePremiereFois:=repos();
    2 : mainChambrePremiereFois:=coffreChambre('');
    3 : mainChambrePremiereFois:=VILLE;
    4 : mainChambrePremiereFois:=TAVERNE;
  end;
end;

//Affichage de la chambre
function  mainChambre() : Lieu;
begin
  afficherInterfacePrincipale('Dans votre chambre');

  deplacerCurseurXY(30,7);write('Vous êtes dans votre chambre. Un petit feu crépite dans la cheminée dégageant une douce cha');
  deplacerCurseurXY(30,8);write('leur et une légère lumière dans toute la salle. Sur les murs se trouvent de nombreux objets');
  deplacerCurseurXY(30,9);write('principalement des trophées de la guilde des Thanes.');

  deplacerCurseurXY(30,11);write('Dans un coin de la chambre se trouve un lit dans lequel vous pouvez vous reposer.');

  deplacerCurseurXY(30,13);write('Près de la porte, un grand coffre contient les différentes armes et armures que vous avez');
  deplacerCurseurXY(30,14);write('obtenues au cours de vos nombreuses aventures.');

  deplacerCurseurXY(30,16);write('Enfin, une porte en bois donne accès à la cour principale de la ville de laquelle provient');
  deplacerCurseurXY(30,17);write('le bruit rassurant de l''activité de la Moria.');

  couleurTexte(White);
  deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
  deplacerCurseurZoneAction(3);write('     1/ Vous reposer dans votre lit');
  deplacerCurseurZoneAction(4);write('     2/ Regarder dans votre coffre');
  deplacerCurseurZoneAction(5);write('     3/ Sortir de votre chambre'); 
  deplacerCurseurZoneAction(6);write('     4/ Aller à la Taverne');
  mainChambre:=QUITTER;
  case ChoixMenu(1,4) of
    1 : mainChambre:=repos();
    2 : mainChambre:=coffreChambre('');
    3 : mainChambre:=VILLE;
    4 : mainChambre:=TAVERNE;
  end;
end;
  

  
end.