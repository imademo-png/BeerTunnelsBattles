unit unitMetierEquipement;
{$codepage utf8}
{$mode objfpc}{$H+}

interface
//TYPES
type
  Tmateriaux = (AUCUN,CUIVRE,FER,ACIER,MITHRIL);                             //Matériaux pour les armes et armures
  TtypeArme = (EPEE,HACHE,MARTEAU);
  TemplacementArmure = (CASQUE,TORSE,GANTS,JAMBIERES,BOTTES);        //Emplacements d'armures
  TarmuresPossedees = array[TemplacementArmure,Tmateriaux] of boolean; //Armures possédées
  TarmesPossedees = array[TtypeArme,Tmateriaux] of boolean;            //Armes possédées
  
//Fonctions et procédures
//Initialise l'équipement
procedure initialisationEquipement();
//Gestion de l'affichage (chaine de caractères) d'un matériau
//mat : le matériau
function materiauxToString(mat : Tmateriaux) : String;
//Gestion de l'affichage (chaine de caractères) d'une pièce d'armure
//armure : la pièce d'armure
//mat : le matériau de celle-ci
function armureToString(armure : TemplacementArmure; mat : Tmateriaux) : String; 
//Gestion de l'affichage (chaine de caractères) d'une arme
//arme : type de l'arme
//mat : le matériau de l'arme
function armeToString(arme:TtypeArme; mat : Tmateriaux) : String;  
//Gestion de l'affichage (chaine de caractères) d'une recette d'armure
//arme : type de l'arme
//mat : le matériau de l'arme
function recetteToString(arme:TtypeArme;mat : Tmateriaux) : string;
//Gestion de l'affichage (chaine de caractères) d'une recette d'armure
//armure : type de l'armure
//mat : le matériau de l'arme
function recetteToString(armure:TemplacementArmure;mat : Tmateriaux) : string;
//L'armure est-elle possédée ?
//armure : type de l'armure
//mat : le matériau de l'arme
function estPossedee(armure : TemplacementArmure; mat : Tmateriaux) : boolean;
//L'arme est-elle possédée ?
//arme : type de l'arme
//mat : matériaux de l'arme
function estPossedee(arme : TtypeArme; mat : Tmateriaux) : boolean;
//L'arme est-elle équipée
//arme : type de l'arme
//mat : matériaux de l'arme
function estEquipee(arme : TtypeArme; mat : Tmateriaux) : boolean;
//L'armure est-elle équipée
//armure : type de l'armure
//mat : matériaux de l'armure
function estEquipee(armure : TemplacementArmure; mat : Tmateriaux) : boolean;
//Equipe ou déséquipe une arme
//arme : type de l'arme
//mat : matériau de l'arme
function Equiper(arme : TtypeArme; mat : Tmateriaux) : string;
//Equipe ou déséquipe une armure
//armure : type de l'armure
//mat : matériau de l'armure
function Equiper(armure : TemplacementArmure; mat : Tmateriaux) : string;
//Le joueur peut-il forger l'armure demandée
//armure : type de l'armure
//mat : matériau de l'armure
function peutForger(armure : TemplacementArmure; mat : Tmateriaux) : boolean;
//Le joueur peut-il forger l'arme demandée
//arme : type de l'arme
//mat : matériau de l'arme
function peutForger(arme : TtypeArme; mat : Tmateriaux) : boolean;
//Arme équipée par le joueur
function armeEquipee() : string;
//Armure équipée
//emplacement : emplacement de l'armure recherchée
function armureEquipee(emplacement : TemplacementArmure) : string;
//Forge une arme si possible
//arme : type de l'arme
//mat : matériau de l'arme
function forgerArme(arme : TtypeArme; mat : Tmateriaux) : string;
//Forge une armure si possible
//armure : type de l'armure
//mat : matériau de l'armure
function forgerArmure(armure : TemplacementArmure; mat : Tmateriaux) : string;
//Calcul les dégats de l'arme
function calculDegat() : integer;
//Calcul l'armure du joueur
function calculArmure() : integer;
//Détermine si un coup étourdi ou non
function etourdi() : boolean;

implementation
uses
  SysUtils, Classes,unitMetierInventaire,unitMetierPersonnage;

type
  tRecetteArmure = array[TemplacementArmure,Tmateriaux,Tressources] of Integer;   //recette d'armure
  tRecetteArme = array[TtypeArme,Tmateriaux,Tressources] of Integer;              //recette d'arme
  tArmureEquipee = array[TemplacementArmure] of Tmateriaux;                       //Armure équipée par le joueur

var
  armuresPossedees : TarmuresPossedees;   //Armures possédées par le joueur
  armesPossedees : TarmesPossedees;       //Armes possédées par le joueur
  recettesArmures : tRecetteArmure;       //Recettes des armures
  recettesArmes : tRecetteArme;           //Recettes des armes
  typeArmeEquipee : TtypeArme;             //Type arme équipée
  materiauArmeEquipee : Tmateriaux;        //Materiau arme équipée
  armureEquipeePersonnage : tArmureEquipee;         //Armures equipées

//L'arme est-elle équipée
//arme : type de l'arme
//mat : matériaux de l'arme
function estEquipee(arme : TtypeArme; mat : Tmateriaux) : boolean;
begin
  estEquipee := ((typeArmeEquipee = arme) AND (materiauArmeEquipee=mat));
end;

//L'armure est-elle équipée
//armure : type de l'armure
//mat : matériaux de l'armure
function estEquipee(armure : TemplacementArmure; mat : Tmateriaux) : boolean;
begin
  estEquipee := (armureEquipeePersonnage[armure] = mat);
end;

//Equipe ou déséquipe une arme
//arme : type de l'arme
//mat : matériau de l'arme
function Equiper(arme : TtypeArme; mat : Tmateriaux) : string;
begin
  if(estPossedee(arme,mat)) then
  begin
    Equiper:='';
    if (estEquipee(arme,mat)) then materiauArmeEquipee := AUCUN
    else 
    begin
      typeArmeEquipee := arme;
      materiauArmeEquipee := mat;
    end;
  end
  else Equiper:='Vous ne possédez pas cette arme !';
  
end;

//Equipe ou déséquipe une armure
//armure : type de l'armure
//mat : matériau de l'armure
function Equiper(armure : TemplacementArmure; mat : Tmateriaux) : string;
begin
  if(estPossedee(armure,mat)) then
  begin
    Equiper := '';
    if(estEquipee(armure,mat)) then armureEquipeePersonnage[armure] := AUCUN
    else armureEquipeePersonnage[armure] := mat;
  end
  else Equiper := 'Vous ne possédez pas cette armure !';
end;

//L'arme est-elle possédée ?
//arme : type de l'arme
//mat : le matériau de l'arme
function estPossedee(arme : TtypeArme; mat : Tmateriaux) : boolean;
begin
  estPossedee := armesPossedees[arme,mat];
end;

//L'armure est-elle possédée ?
//armure : type de l'armure
//mat : le matériau de l'arme
function estPossedee(armure : TemplacementArmure; mat : Tmateriaux) : boolean;
begin
  estPossedee := armuresPossedees[armure,mat];
end;

//Initialise l'équipement
procedure initialisationEquipement();
var
  mat : Tmateriaux;
  res : Tressources;
  armure : TemplacementArmure;
  arme : TtypeArme;
begin
  //Equipement possédé et des recettes
  for mat := Low(Tmateriaux) to High(Tmateriaux) do
  begin
    for armure := Low(TemplacementArmure) to High(TemplacementArmure) do 
    begin
      armuresPossedees[armure,mat] := (mat = CUIVRE);
      for res := Low(Tressources) to High(Tressources) do recettesArmures[armure,mat,res] := 0;
      recettesArmures[armure,mat,MINOR] := 250;
    end;
    for arme := Low(TtypeArme) to High(TtypeArme) do
    begin
      armesPossedees[arme,mat] := ((mat = CUIVRE) AND (arme = HACHE));
      for res := Low(Tressources) to High(Tressources) do recettesArmes[arme,mat,res] := 0;
      recettesArmes[arme,mat,MINOR] := 500;
    end; 
  end;

  //Equipement porté
  typeArmeEquipee := HACHE;
  materiauArmeEquipee := AUCUN;
  for armure := Low(TemplacementArmure) to High(TemplacementArmure) do armureEquipeePersonnage[armure] := AUCUN;

  //Recettes
  recettesArmes[EPEE,CUIVRE,MINCUIVRE] := 5;
  recettesArmes[HACHE,CUIVRE,MINCUIVRE] := 7;
  recettesArmes[MARTEAU,CUIVRE,MINCUIVRE] := 10;
  recettesArmes[EPEE,FER,MINFER] := 5;
  recettesArmes[HACHE,FER,MINFER] := 7;
  recettesArmes[MARTEAU,FER,MINFER] := 10;
  recettesArmes[EPEE,ACIER,MINFER] := 5;
  recettesArmes[HACHE,ACIER,MINFER] := 7;
  recettesArmes[MARTEAU,ACIER,MINFER] := 10;
  recettesArmes[EPEE,ACIER,MINCHARBON] := 5;
  recettesArmes[EPEE,MITHRIL,MINMITHRIL] := 10;
  recettesArmes[HACHE,ACIER,MINCHARBON] := 7;
  recettesArmes[HACHE,MITHRIL,MINMITHRIL] := 13;
  recettesArmes[MARTEAU,ACIER,MINCHARBON] := 10;
  recettesArmes[MARTEAU,MITHRIL,MINMITHRIL] := 16;

  recettesArmures[CASQUE,CUIVRE,MINCUIVRE] := 5;
  recettesArmures[CASQUE,FER,MINFER] := 5;
  recettesArmures[CASQUE,ACIER,MINFER] := 5;
  recettesArmures[CASQUE,ACIER,MINCHARBON] := 5;
  recettesArmures[CASQUE,MITHRIL,MINMITHRIL] := 5;

  recettesArmures[TORSE,CUIVRE,MINCUIVRE] := 10;
  recettesArmures[TORSE,FER,MINFER] := 10;
  recettesArmures[TORSE,ACIER,MINFER] := 10;
  recettesArmures[TORSE,ACIER,MINCHARBON] := 10;
  recettesArmures[TORSE,MITHRIL,MINMITHRIL] := 15;
  recettesArmures[GANTS,CUIVRE,MINCUIVRE] := 5;
  recettesArmures[GANTS,FER,MINFER] := 5;
  recettesArmures[GANTS,ACIER,MINFER] := 5;
  recettesArmures[GANTS,ACIER,MINCHARBON] := 5;
  recettesArmures[GANTS,MITHRIL,MINMITHRIL] := 8;
  
  recettesArmures[JAMBIERES,CUIVRE,MINCUIVRE] := 7;
  recettesArmures[JAMBIERES,FER,MINFER] := 7;
  recettesArmures[JAMBIERES,ACIER,MINFER] := 7;
  recettesArmures[JAMBIERES,ACIER,MINCHARBON] := 7;
  recettesArmures[JAMBIERES,MITHRIL,MINMITHRIL] := 13;
  
  recettesArmures[BOTTES,CUIVRE,MINCUIVRE] := 5;
  recettesArmures[BOTTES,FER,MINFER] := 5;
  recettesArmures[BOTTES,ACIER,MINFER] := 5;
  recettesArmures[BOTTES,ACIER,MINCHARBON] := 5;
  recettesArmures[BOTTES,MITHRIL,MINMITHRIL] := 8;
  
end;



//Le joueur peut-il forger l'arme demandée
//arme : type de l'arme
//mat : matériau de l'armure
function peutForger(arme : TtypeArme; mat : Tmateriaux) : boolean;
var
  res : Tressources;
begin
  peutForger := true;
  for res := Low(Tressources) to High(Tressources) do
    if quantiteResources(res) < recettesArmes[arme,mat,res] then peutForger := false;
end;


//Le joueur peut-il forger l'armure demandée
//armure : type de l'armure
//mat : matériau de l'armure
function peutForger(armure : TemplacementArmure; mat : Tmateriaux) : boolean;
var
  res : Tressources;
begin
  peutForger := true;
  for res := Low(Tressources) to High(Tressources) do
    if quantiteResources(res) < recettesArmures[armure,mat,res] then peutForger := false;
end;

//Forge une arme si possible
//arme : type de l'arme
//mat : matériau de l'arme
function forgerArme(arme : TtypeArme; mat : Tmateriaux) : string;
var
  res : Tressources;
begin
  if(peutForger(arme,mat) AND not(estPossedee(arme,mat))) then
  begin
    forgerArme := '';
    armesPossedees[arme,mat] := true;
    for res := Low(Tressources) to High(Tressources) do
      ajouterResources(res,recettesArmes[arme,mat,res]*(-1));
  end
  else if estPossedee(arme,mat) then forgerArme := 'Vous possédez déjà cette arme !'
  else forgerArme := 'Vous ne possédez pas les ressources pour forger cette arme !';
end;

//Forge une armure si possible
//armure : type de l'armure
//mat : matériau de l'armure
function forgerArmure(armure : TemplacementArmure; mat : Tmateriaux) : string;
var
  res : Tressources;
begin
  if(peutForger(armure,mat) AND not(estPossedee(armure,mat))) then
  begin
    forgerArmure := '';
    armuresPossedees[armure,mat] := true;
    for res := Low(Tressources) to High(Tressources) do
      ajouterResources(res,recettesArmures[armure,mat,res]*(-1));
  end
  else if estPossedee(armure,mat) then forgerArmure := 'Vous possédez déjà cette armure !'
  else forgerArmure := 'Vous ne possédez pas les ressources pour forger cette armure !';
end;

//Arme équipée par le joueur
function armeEquipee() : string;
begin
  armeEquipee := armeToString(typeArmeEquipee,materiauArmeEquipee);
end;

//Armure équipée
//emplacement : emplacement de l'armure recherchée
function armureEquipee(emplacement : TemplacementArmure) : string;
begin
  armureEquipee:= armureToString(emplacement,armureEquipeePersonnage[emplacement]);
end;

//GEstion de l'affichage (chaine de caractères) d'une recette d'arme
//arme : type de l'arme
//mat : le matériau de l'arme
function recetteToString(arme:TtypeArme;mat : Tmateriaux) : string;
var
  res : Tressources;
begin
  recetteToString := '';
  for res := Low(Tressources) to High(Tressources) do
  begin
      if(recettesArmes[arme,mat,res] <> 0) then
      begin
        if(recetteToString <> '') then recetteToString += ', ';
        recetteToString += (IntToStr(recettesArmes[arme,mat,res])+' '+resourcesToString(res));
      end;
  end;
end;

//Gestion de l'affichage (chaine de caractères) d'une recette d'armure
//armure : type de l'armure
//mat : le matériau de l'arme
function recetteToString(armure:TemplacementArmure;mat : Tmateriaux) : string;
var
  res : Tressources;
begin
  recetteToString := '';
  for res := Low(Tressources) to High(Tressources) do
  begin
      if(recettesArmures[armure,mat,res] <> 0) then
      begin
        if(recetteToString <> '') then recetteToString += ', ';
        recetteToString += (IntToStr(recettesArmures[armure,mat,res])+' '+resourcesToString(res));
      end;
  end;
end;

//Gestion de l'affichage (chaine de caractères) d'un matériau
//mat : le matériau
function materiauxToString(mat : Tmateriaux) : String;
begin
  materiauxToString := '';
  case mat of
    CUIVRE : materiauxToString += 'cuivre';
    FER : materiauxToString += 'fer';
    ACIER : materiauxToString += 'acier';
    MITHRIL : materiauxToString += 'mithril';
  end;
end;

//Gestion de l'affichage (chaine de caractères) d'une pièce d'armure
//armure : la pièce d'armure
//mat : le matériau de celle-ci
function armureToString(armure : TemplacementArmure; mat : Tmateriaux) : String; 
begin
  if(mat = AUCUN) then armureToString := 'Aucun'
  else
  begin
    case armure of
      CASQUE : armureToString := 'Casque';
      TORSE : armureToString := 'Torse';
      GANTS : armureToString := 'Gants';
      JAMBIERES : armureToString := 'Jambières';
      BOTTES : armureToString := 'Bottes';
    end;
    armureToString += ' en '+materiauxToString(mat);
  end;
end;


//Gestion de l'affichage (chaine de caractères) d'une arme
//arme : type de l'arme
//mat : le matériau de l'arme
function armeToString(arme:TtypeArme; mat : Tmateriaux) : String;  
begin
  if(mat = AUCUN) then armeToString := 'Vos poings'
  else
  begin
    case arme of
      EPEE : armeToString := 'Epée';
      HACHE : armeToString := 'Hache';
      MARTEAU : armeToString := 'Marteau';
    end;
    armeToString += ' en '+materiauxToString(mat);
  end;
end;


//Calcul les dégats de l'arme
function calculDegat() : integer;
var
  degatBase : integer;
  alea : integer;
  probacritique : integer;
begin

  case materiauArmeEquipee of
    AUCUN : degatBase := 5;
    CUIVRE : degatBase := 10;
    FER : degatBase := 20;
    ACIER : degatBase := 40; 
    MITHRIL : degatBase := 100;
  end;

  calculDegat:=degatBase;
  if(materiauArmeEquipee <> AUCUN) then
  begin
    case typeArmeEquipee of
      EPEE : if random(10) = 0 then calculDegat:=2*degatBase;
      HACHE : calculDegat += (degatBase div 5);
      MARTEAU : calculDegat += (degatBase div 10);
    end; 
  end;
  if(getBonusPersonnage() = FORCE) then calculDegat += 2;

  alea := random(100);
  if(getBonusPersonnage() = CRITIQUE) then probacritique := 20
  else probacritique := 10;
  if( alea < probacritique) then calculDegat *= 2;
end;

//Détermine si un coup étourdi ou non
function etourdi() : boolean;
begin
  etourdi:=false;
  if (materiauArmeEquipee <> AUCUN) AND (typeArmeEquipee = MARTEAU) then etourdi := (random(5)=0)
end;

//Calcul l'armure du joueur
function calculArmure() : integer;
var
  valeur : integer;
  armure : TemplacementArmure;
begin
  valeur := 0;
  for armure := Low(TemplacementArmure) to High(TemplacementArmure) do
  begin
    case armureEquipeePersonnage[armure] of
      CUIVRE : valeur += 1;
      FER : valeur += 3;
      ACIER : valeur += 6;
      MITHRIL : valeur += 12;
    end;
  end;
  calculArmure := valeur;
end;


end.