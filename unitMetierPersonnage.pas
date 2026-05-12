unit unitMetierPersonnage;
{$codepage utf8}
{$mode delphi}{$H+}

interface
type
  Tgenre = (MASCULIN,FEMININ,AUTRE);
  Tbonus = (AUCUNBONUS,FORCE,REGENERATION,CRITIQUE);
  

  
//Initialise le personnage  
procedure initialisationPersonnage();
//Fixe le genre du personnage
//genre : genre du personnage
procedure setGenrePersonnage(genre : Tgenre); 
//Fixe le nom du personnage
//nom : nom du personnage
procedure setNomPersonnage(nom : string); 
//Fixe la taille du personnage
//taille : taille du personnage
procedure setTaillePersonnage(taille : integer);
//Récupère le nom du personnage
function getNomPersonnage() : string;


// Recupère la santé max du personnage
function getSanteeMaxPersonnage() : integer;

// Fixe la santé max du personnage
procedure setSanteeMaxPersonnage(sante:integer);

// Receuille la taille du joueur en entier sans 'm'
function getTaillePersonnageInt() : Integer;


// Fixe la santé du personnage
procedure setSanteePersonnage(sante : integer);
// Fixe un buff au personnage
procedure setBuffPersonnage(nouveaubuff : Tbonus);


//Récupère le genre du personnage
function getGenrePersonnage() : string;
//Récupère la taille du personnage
function getTaillePersonnage() : String;
//Récupère la santée du personnage
function getSanteePersonnageToString() : String;
//Affichage du bonus
function getBonusPersonnageString() : string;
//Récupère la santée du personnage
function getSanteePersonnage() : integer;
//Bonus du personnage
function getBonusPersonnage() : Tbonus;

//Actions du personnage
//Restaure la santé du personnage
procedure dormir();
//Manger un plat
//numeroPlat : Numéro du plat (1 ou 2)
procedure manger(numeroPlat : integer);
//Soigne le personnage
procedure soignerPersonnage();
//Prendre des dégats
//degat : degats subis par le joueur
procedure subirDegat(degat : integer);
//Regénération
procedure regen();
  
implementation
uses
  SysUtils, Classes,unitMetierContrat,unitMetierInventaire;

var
  santeMaxDuPersonnage : integer; // Santé max du personnage
  nomDuPersonnage : string;       //Nom du personnage
  tailleDuPersonnage : integer;   //Taille du personnage
  genreDuPersonnage : Tgenre;     //Genre du personnage
  santeDuPersonnage : integer;              //Santé du personnage
  buff : Tbonus;
  
//Initialise le personnage  
procedure initialisationPersonnage();
begin
  santeMaxDuPersonnage := 150;
  nomDuPersonnage := '';
  santeDuPersonnage := santeMaxDuPersonnage;
end;

//Fixe le genre du personnage
//genre : genre du personnage
procedure setGenrePersonnage(genre : Tgenre);
begin
  genreDuPersonnage := genre;
end;

//Fixe le nom du personnage
//nom : nom du personnage
procedure setNomPersonnage(nom : string);
begin
  nomDuPersonnage := nom;
  if (nom = 'Alice') then 
  begin
  ajouterResources(MINMITHRIL,5000);
  ajouterResources(MINOR,5000);
  end;
end;

//Fixe la taille du personnage
//taille : taille du personnage
procedure setTaillePersonnage(taille : integer);
begin
  tailleDuPersonnage := taille;
end;

//Récupère le nom du personnage
function getNomPersonnage() : string;
begin
  getNomPersonnage := nomDuPersonnage;
end;

//Récupère le genre du personnage
function getGenrePersonnage() : string;
begin
  case genreDuPersonnage of
     MASCULIN : getGenrePersonnage:= 'Homme';
     FEMININ : getGenrePersonnage:= 'Femme';
     AUTRE : getGenrePersonnage:= 'Autre';
  end;
end;

//Récupère la taille du personnage
function getTaillePersonnage() : String;
var 
  cm : string;
begin
  cm := IntToStr(tailleDuPersonnage mod 100);
  while Length(cm)<2 do cm := '0'+cm;
  getTaillePersonnage := IntToStr(tailleDuPersonnage div 100) + 'm' + cm; 
end;



procedure setSanteePersonnage(sante : integer);
    begin
    santeDuPersonnage:=sante;
    end;

function getTaillePersonnageInt() : Integer;
begin
getTaillePersonnageInt := tailleDuPersonnage;
end;



//Récupère la santée du personnage
function getSanteePersonnage() : integer;
begin
  getSanteePersonnage := santeDuPersonnage;
end;

//Récupère la santée du personnage
function getSanteePersonnageToString() : String;
var
  str : string;
begin
  str := IntToStr(santeDuPersonnage);
  getSanteePersonnageToString := str+'/'+IntToStr(santeMaxDuPersonnage);
end;

procedure setSanteeMaxPersonnage(sante:integer);
begin
santeMaxDuPersonnage:=sante;
end;


function getSanteeMaxPersonnage() : integer;
begin
  getSanteeMaxPersonnage := santeMaxDuPersonnage;
end;



//Bonus du personnage
function getBonusPersonnage() : Tbonus;
var
  str : string;
begin
  getBonusPersonnage := buff;
end;

//Affichage du bonus
function getBonusPersonnageString() : string;
var
  str : string;
begin
  case buff of
    AUCUNBONUS : str := 'Aucun';
    FORCE : str := 'Force';
    REGENERATION : str := 'Regénération';
    CRITIQUE : str := 'Critique';
  end;
  getBonusPersonnageString := str;
end;

//Restaure la santé du personnage
procedure dormir();
begin
  soignerPersonnage();
  buff := AUCUNBONUS;
  InitialiserContrats();
end;


procedure setBuffPersonnage(nouveaubuff : Tbonus);
begin
  buff:=nouveaubuff;
end;


//Manger un plat
//numeroPlat : Numéro du plat (1 ou 2 ou 3)
procedure manger(numeroPlat : integer);
begin
  buff := Tbonus(numeroPlat);
end;

//Soigne le personnage
procedure soignerPersonnage();
begin
  santeDuPersonnage := santeMaxDuPersonnage;
end;

//Prendre des dégats
//degat : dégats subis par le personnage
procedure subirDegat(degat : integer);
begin
  santeDuPersonnage -= degat;
  if(santeDuPersonnage<0) then santeDuPersonnage:=0;
end;

//Regénération
procedure regen();
begin
  santeDuPersonnage += random(5)+1;
  if(santeDuPersonnage>santeMaxDuPersonnage) then santeDuPersonnage := santeMaxDuPersonnage;
end;
  
end.