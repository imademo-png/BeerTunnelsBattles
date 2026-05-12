unit unitMetierContrat;
{$codepage utf8}
{$mode objfpc}{$H+}

interface
uses
  unitMetierInventaire,unitMetierMonstre;


type
  Tcontrat = record                             //Un contrat pour la mine
    id : integer;                               //Numéro du contrat
    nom : string;                               //Nom du contrat
    niveau : integer;                           //Niveau du contrat
    monstres : array[TtypeMonstre] of integer;  //Nombres de chaque type de monstres
    ressources : array[Tressources] of integer; //Nombres de chaque type de ressources en récompense
    actif:boolean;                              //Le contrat est-il actif
  end;
  TtableauContrat = array of Tcontrat;
  
//Génère les contrats
procedure InitialiserContrats();

//Renvoie la liste des contrats
//=> Un tableau de contrat
function getContrats() : TtableauContrat;

//Contrat actif du joueur
//=> Le contrat choisi par le joueur
function getContratActif() : Tcontrat;

//Enlève le contrat actif du joueur
procedure enleverContratActif();

//Le joueur choisit un contrat
//numero : Numéro du contrat (0..)
procedure choisirContrat(numero : integer);

//Termine le contrat actif
procedure finirContratActif();


implementation
var
  contrats : TtableauContrat; //Tableau des contrats proposés
  contratActif : Tcontrat;    //Contrat choisit par le joueur

//Le joueur choisit un contrat
//numero : Numéro du contrat (0..)
procedure choisirContrat(numero : integer);
begin
  if(contrats[numero].actif) then contratActif := contrats[numero];
end;

//Enlève le contrat actif du joueur
procedure enleverContratActif();
begin
  contratActif.id := -1;
end;

//Contrat actif du joueur
//=> Le contrat choisi par le joueur
function getContratActif() : Tcontrat;
begin
  getContratActif:=contratActif;
end;

//Renvoie la liste des contrats
//=> Un tableau de contrat
function getContrats() : TtableauContrat;
begin
  getContrats := contrats;
end;

//Génère un contrat
//estFacile : le contrat est-il facile
function genererContrat(estFacile : boolean) : Tcontrat;
var
  alea : integer;
  typeMonstre : TtypeMonstre;
  res : Tressources;
  
begin
  //Initialisation des monstres et récompenses
  for typeMonstre := Low(TtypeMonstre) to High(TtypeMonstre) do genererContrat.monstres[typeMonstre] := 0;
  for res := Low(Tressources) to High(Tressources) do genererContrat.ressources[res] := 0;

  //Tirage aléatoire du type de contrat
  alea := random(3);

  //Génération des monstres et du nom du contrat
  case alea of
    0:
    begin
      if(estFacile) then genererContrat.niveau := 1
      else genererContrat.niveau := 2 + random(4);

      if(genererContrat.niveau <= 2) then typeMonstre := GOBLIN
      else if(genererContrat.niveau <= 4) then typeMonstre := ARAIGNEE
      else typeMonstre := TROLL;

      genererContrat.nom := 'Chasse aux '+monstreToString(typeMonstre)+'s';
      
      if(estFacile) then genererContrat.monstres[typeMonstre] := 2
      else genererContrat.monstres[typeMonstre] := 3 + random(4);
    end;
    1:
    begin
      if(estFacile) then genererContrat.niveau := 2
      else genererContrat.niveau := 2 + random(4);

      genererContrat.nom := 'Troll et compagnie';

      genererContrat.monstres[TROLL] := 1;
      if(estFacile) then genererContrat.monstres[GOBLIN] := 1
      else genererContrat.monstres[GOBLIN] := genererContrat.niveau;
    end;
    2:
    begin
      if(estFacile) then genererContrat.niveau := 1
      else genererContrat.niveau := 2 + random(4);

      genererContrat.nom := 'Eleveur d''araignées';
      
      genererContrat.monstres[GOBLIN] := 1;
      if(estFacile) then genererContrat.monstres[ARAIGNEE] := 1
      else genererContrat.monstres[ARAIGNEE] := genererContrat.niveau;
    end;
  end;

  //Génération des récompenses (ressources)
  if(genererContrat.niveau <= 2) then
  begin
    genererContrat.ressources[MINCUIVRE] := 1+random(3)+3*(genererContrat.niveau-1);
  end
  else if(genererContrat.niveau = 3) then
  begin
    genererContrat.ressources[MINCUIVRE] := 5+random(5);
    genererContrat.ressources[MINFER] := 1+random(3);
  end
  else if(genererContrat.niveau = 4) then
  begin
    genererContrat.ressources[MINFER] := 1+random(3);
    genererContrat.ressources[MINCHARBON] := 1+random(3);
  end
  else
  begin
    genererContrat.ressources[MINFER] := 3+random(3);
    genererContrat.ressources[MINCHARBON] := 3+random(3);
  end;
  genererContrat.ressources[MINOR] := 40*genererContrat.niveau+random(20);
end;

//Génère les contrats
procedure InitialiserContrats();
var
  nbContrats : integer;
  i:integer;
begin
  enleverContratActif();
  nbContrats := random(3)+2;
  SetLength(contrats,nbContrats);
  for i:=0 to (nbContrats-1) do
  begin
    contrats[i] := genererContrat(i<2);
    contrats[i].id := i;
    contrats[i].actif := true;
  end;
end;

//Termine le contrat actif
procedure finirContratActif();
var
  res : Tressources;
begin
  contrats[contratActif.id].actif := false;
  for res := Low(Tressources) to High(Tressources) do ajouterResources(res,contratActif.ressources[res]);
  enleverContratActif();
end;
  

  
end.