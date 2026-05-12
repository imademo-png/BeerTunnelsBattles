unit unitMetierMonstre;
{$codepage utf8}
{$mode objfpc}{$H+}

interface
type
  TtypeMonstre = (GOBLIN,TROLL,ARAIGNEE);
  Tetat = (NORMAL,ETOURDI1,ETOURDI2,ETOURDI3);
  Tmonstre = record
    typeMonstre : TtypeMonstre;
    sante : integer;
    degat : integer;
    armure : integer;
    etat : Tetat;
  end;

//Affichage du nom d'un monstre
 function  monstreToString(monstre : TtypeMonstre) : string;
//Génère un monstre
//typeMonstre : type du monstre
function newMonstre(typeMonstre : TtypeMonstre) : Tmonstre;
//Affichage de l'état
//etat : l'état à afficher
function etatToString(etat : Tetat) : string;
//étourdi le monstre
//monstre : le monstre à étourdir
procedure etourdirMonstre(var monstre : Tmonstre);
//Attaque un monstre
//monstre : le monstre à attaquer
function attaquer(var monstre : Tmonstre) : integer;
//Attaque du monstre
//monstre : le monstre attaquant
function attaqueMonstre(monstre : Tmonstre) : integer;
//Fait évoluer l'état du monstre
//monstre : le monstre dont l'état évolu
procedure evolutionEtat(var monstre : Tmonstre);
  
implementation
uses
  unitMetierEquipement,unitMetierPersonnage;
//Affichage de l'état
//etat : l'état à afficher
function etatToString(etat : Tetat) : string;
begin
  case etat of
    NORMAL : etatToString:='Normal';
    ETOURDI1 : etatToString:='Etourdi (1 tour)';
    ETOURDI2 : etatToString:='Etourdi (2 tours)';
    ETOURDI3 : etatToString:='Etourdi (3 tours)';
  end;
end;
//Affichage du nom d'un monstre
function  monstreToString(monstre : TtypeMonstre) : string;
begin
  case monstre of
    GOBLIN : monstreToString := 'Goblin';
    TROLL : monstreToString := 'Troll';
    ARAIGNEE : monstreToString := 'Araignée';
  end;
end;

//Génère un monstre
//typeMonstre : type du monstre
function newMonstre(typeMonstre : TtypeMonstre) : Tmonstre;
begin
  newMonstre.typeMonstre := typeMonstre;
  newMonstre.etat := NORMAL;

  case typeMonstre of
    GOBLIN : 
    begin
      newMonstre.sante := 30;
      newMonstre.armure := 5;
      newMonstre.degat := 5;
    end;
    ARAIGNEE : 
    begin
      newMonstre.sante := 30;
      newMonstre.armure := 0;
      newMonstre.degat := 15;
    end;
    TROLL : 
    begin
      newMonstre.sante := 100;
      newMonstre.armure := 10;
      newMonstre.degat := 20;
    end;
  end;
end;

//étourdi le monstre
//monstre : le monstre à étourdir
procedure etourdirMonstre(var monstre : Tmonstre);
begin
  if(monstre.sante > 0) then monstre.etat := ETOURDI3;
end;

//Attaque un monstre
//monstre : le monstre à attaquer
function attaquer(var monstre : Tmonstre) : integer;
var 
  degat : integer;
begin
  attaquer := -1;
  if(monstre.sante >0) then
  begin
    degat := calculDegat()-random(monstre.armure+1);
    if(degat < 0) then degat := 0;

    monstre.sante -= degat;
    if etourdi() AND (monstre.etat = NORMAL) then monstre.etat := ETOURDI1; 

    if(monstre.sante < 0) then 
    begin
      monstre.sante := 0;
      monstre.etat := NORMAL;
    end;

    attaquer := degat;
  end;
end;

//Attaque du monstre
//monstre : le monstre attaquant
function attaqueMonstre(monstre : Tmonstre) : integer;
var
  degat : integer;
begin
  degat := monstre.degat-random(calculArmure());
  if(degat <0) then degat:=0;
  subirDegat(degat);
  attaqueMonstre := degat;
end;

//Fait évoluer l'état du monstre
//monstre : le monstre dont l'état évolu
procedure evolutionEtat(var monstre : Tmonstre);
begin
  case monstre.etat of
    ETOURDI1: monstre.etat:=NORMAL;
    ETOURDI2: monstre.etat:=ETOURDI1;
    ETOURDI3: monstre.etat:=ETOURDI2;
  end;
end;
  
end.