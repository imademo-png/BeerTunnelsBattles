unit unitMetierInventaire;
{$codepage utf8}
{$mode objfpc}{$H+}

interface
//TYPES
type
  Tressources = (MINCUIVRE,MINFER,MINCHARBON,MINOR,MINMITHRIL);
  TinventaireResources = array[Tressources] of Integer;
  Tobjets = (POTION,BOMBE);
  TinventaireObjets = array[Tobjets] of integer;
  
//Initialise l'inventaire du joueur
procedure initialisationInventaire();
//Renvoie la quantité de l'objet demandé
//res : ressources désirées
function quantiteObjet(obj : Tobjets) : integer;
//Renvoie la quantité de ressources possédées
//res : ressources désirées
function quantiteResources(res : Tressources) : integer;
//Affichage d'une ressource
//res : ressources désirées
function resourcesToString(res : Tressources) : string;

//Ajoute la quantité à la ressources données
//res : ressources à modifier
//quantite : quantité à ajouter
procedure ajouterResources(res : Tressources; quantite : integer);


procedure ajouterObjets(res: Tobjets; quantite: integer);


//Acheter un objet
//numéro : le numéro de l'objet
function acheterObjet(numero : integer) : string;
//Consomme un objet
//objet : le type de l'objet
procedure consommerObjet(objet : Tobjets);
implementation
var
  inventaireResources : TinventaireResources;
  inventaireObjets : TinventaireObjets;


//Renvoie la quantité de l'objet demandé
//res : ressources désirées
function quantiteObjet(obj : Tobjets) : integer;
begin
  quantiteObjet := inventaireObjets[obj];
end;

//Renvoie la quantité de ressources possédées
//res : ressources désirées
function quantiteResources(res : Tressources) : integer;
begin
  quantiteResources := inventaireResources[res];
end;

//Ajoute la quantité à la ressources données
//res : ressources à modifier
//quantite : quantité à ajouter
procedure ajouterResources(res : Tressources; quantite : integer);
begin
  inventaireResources[res] += quantite;
end;



procedure ajouterObjets(res: Tobjets; quantite: integer);
begin
  inventaireObjets[res] += quantite;
end;

//Initialise l'inventaire du joueur
procedure initialisationInventaire();
var
  res : Tressources;
  obj : Tobjets;
begin
  for res := low(Tressources) to High(Tressources) do
  begin
    inventaireResources[res] := 0;
  end;
    inventaireResources[MINOR] := 200;

  for obj := low(Tobjets) to High(Tobjets) do
    inventaireObjets[obj] := 0;
end;

//Affichage d'une ressource
function resourcesToString(res : Tressources) : string;
begin
  resourcesToString:='';
  case res of
    MINCHARBON : resourcesToString:='charbon';
    MINCUIVRE : resourcesToString:='cuivre';
    MINFER : resourcesToString:='fer';
    MINOR : resourcesToString:='or';
    MINMITHRIL : resourcesToString:='mithril';
  end;
end;

//Acheter un objet
//numéro : le numéro de l'objet
function acheterObjet(numero : integer) : string;
var
  orNecessaire : integer;
begin
  case numero of
    1: orNecessaire := 100;
    2: orNecessaire := 50;
  end;
  if(quantiteResources(MINOR) < orNecessaire) then acheterObjet:='Vous n''avez pas assez d''or pour cet achat !'
  else
  begin
    ajouterResources(MINOR,-orNecessaire);
    inventaireObjets[Tobjets(numero-1)] += 1;
  end;
end;

//Consomme un objet
//objet : le type de l'objet
procedure consommerObjet(objet : Tobjets);
begin
  inventaireObjets[objet] := inventaireObjets[objet]-1;
end;
  
end.