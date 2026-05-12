unit unitVueContrat;
{$codepage utf8}
{$mode objfpc}{$H+}

interface
uses
  unitVueLieu;

//Fonctions et procédures
//Affichage des contrats
function  mainContrat(message : string) : Lieu;
  
  
implementation
uses
  SysUtils, Classes,GestionEcran,unitVueIHM,unitMetierContrat,unitMetierInventaire;

procedure afficherContrat(contrat : Tcontrat);
var
  colonne : integer;
  resStr : string;
  res : Tressources;
  couleur : byte;
begin
  couleur := white;
  if(contrat.id = getContratActif().id) then couleur := green;

  colonne := 6;
  if(contrat.id>=3) then colonne:=80;

  resStr := '';
  for res := Low(Tressources) to High(Tressources) do
  begin
    if(contrat.ressources[res] <> 0) AND (res <> MINOR) then
    begin
      if(resStr <> '') then resStr := resStr + ', ';
      resStr := resStr + resourcesToString(res);
    end;
  end;

  dessinerCadreXY(colonne-1,7+7*(contrat.id mod 3),colonne+60,12+7*(contrat.id mod 3),simple,couleur,Black);
  deplacerCurseurXY(colonne+3,8+7*(contrat.id mod 3));write('CONTRAT N°',(contrat.id+1));
  deplacerCurseurXY(colonne+3,9+7*(contrat.id mod 3)); write('        NOM : ',contrat.nom,' (niv ',contrat.niveau,')');
  deplacerCurseurXY(colonne+3,10+7*(contrat.id mod 3));write('      PRIME : ',contrat.ressources[MINOR],' pièces d''or');
  deplacerCurseurXY(colonne+3,11+7*(contrat.id mod 3));write(' RESSOURCES : ',resStr);
  couleurTexte(white);
end;

//Ecran de sélection des contrats
function choixContrat() : Lieu;
var 
  contrats : TtableauContrat;
  i:integer;
  choix : integer;
begin
  choix := -1;
  while(choix <> 0) do
  begin
    afficherInterfacePrincipale('Tableau des contrats'); 
    deplacerCurseurXY(63,5);write('Contrats disponibles :');

    contrats := getContrats();
    for i:=Low(contrats) to High(contrats) do
    begin
      if(contrats[i].actif) then afficherContrat(contrats[i]);
    end;


    deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
    deplacerCurseurZoneAction(3);write('     ?/ Choisir un contrat');
    deplacerCurseurZoneAction(4);write('     0/ S''écarter du panneau');

    choixContrat:=QUITTER;
    choix := ChoixMenu(0,Length(contrats));
    case choix of
      0 : choixContrat:=CONTRAT;
      else choisirContrat(choix-1);
    end;
  end;
end;

//Affichage des contrats
function  mainContrat(message : string) : Lieu;
var
  sortir : boolean;
begin    
  sortir := False;

  while(not(sortir)) do
  begin
    afficherInterfacePrincipale('Tableau des contrats');  

    deplacerCurseurXY(29,7);write('Les torches vacillent dans l''air vicié des mines. Le cliquetis des pioches résonne au loin,');
    deplacerCurseurXY(29,8);write('un chant métallique mêlé au grondement sourd des profondeurs. Tu avances dans la grande sal');
    deplacerCurseurXY(29,9);write('le commune, là où les guerriers de la Moria se rassemblent. Au centre, trônant fièrement,');
    deplacerCurseurXY(29,10);write('le tableau des contrats, une relique d''acier martelé et de parchemins griffonnés.');

    deplacerCurseurXY(29,12);write('Des affiches y dansent sous l''effet des courants d''air, chacune décrivant une menace ou une');
    deplacerCurseurXY(29,13);write('mission. Quelques silhouettes robustes, armées de haches et de boucliers ornés, scrutent les');
    deplacerCurseurXY(29,14);write('tâches à accomplir.');


    deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
    deplacerCurseurZoneAction(3);write('     1/ Consulter les contrats');
    deplacerCurseurZoneAction(4);write('     2/ Partir en mission');
    deplacerCurseurZoneAction(5);write('     3/ Retourner dans le hall central');

    if(message <> '') then afficherMessageErreur(message);

    mainContrat:=QUITTER;
    sortir := true;
    case ChoixMenu(1,3) of
      1 : mainContrat:=choixContrat();
      2 :
      begin
        mainContrat:=MINE;
        if(getContratActif().id = -1) then
        begin
          sortir := false;
          message := 'Vous n''avez pas de contrat actif !';
        end;
      end;
      3 : mainContrat:=VILLE;
    end;
  end;
end;
  

  
end.