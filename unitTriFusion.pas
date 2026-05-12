Unit UnitTrifusion;
{$codepage utf8}
{$mode objfpc}{$H+}

interface
uses unitStructures;
{type
  PCellule = ^Cellule;
  Cellule = record
    valeur: string;
    suivant: PCellule;
  end;}

procedure TriFusionParBonus(var tete: PCellule);
procedure TriFusion(var tete: PCellule);  // Ajout dans l'interface
implementation
uses
  SysUtils;
procedure DiviserListe(tete: PCellule; var gauche, droite: PCellule);
var
  milieu1, milieu2: PCellule;

begin
  if (tete = nil) or (tete^.suivant = nil) then      //si la liste est vide ou contient un seul element, on ne divise pas 
  begin
    gauche := tete;
    droite := nil;
    Exit;
  end;

  milieu1 := tete;
  milieu2 := tete^.suivant;

  while (milieu2 <> nil) and (milieu2^.suivant <> nil) do      //on utilise deux pointeurs pour trouver le milieu de la liste
  begin
    milieu1 := milieu1^.suivant;
    milieu2 := milieu2^.suivant^.suivant;
  end;

  gauche := tete;
  droite := milieu1^.suivant;
  milieu1^.suivant := nil;
end;

function FusionnerListes(gauche, droite: PCellule): PCellule;  //Cette fonction remonte les elements en les triants
var
  resultat: PCellule;
begin
  if gauche = nil then
    Exit(droite)
  else if droite = nil then
    Exit(gauche);

  if gauche^.valeur <= droite^.valeur then
  begin
    resultat := gauche;
    resultat^.suivant := FusionnerListes(gauche^.suivant, droite);
  end
  else
  begin
    resultat := droite;
    resultat^.suivant := FusionnerListes(gauche, droite^.suivant);
  end;

  Exit(resultat);
end;

procedure TriFusion(var tete: PCellule);     // Procedure tri fusion qui regroupe toutes les autre dont on a besoin pour trier notre liste de recettes
var
  gauche, droite: PCellule;
begin
  if (tete = nil) or (tete^.suivant = nil) then
    Exit;

  DiviserListe(tete, droite, gauche);

  TriFusion(gauche);
  TriFusion(droite);

  tete := FusionnerListes(gauche, droite);
end;



function ExtraireBonus(const valeur: string): string;
var
  posDebut: Integer;
begin
  // Trouve la position du dernier '(' pour extraire le bonus
  posDebut := LastDelimiter('(', valeur);
  if posDebut > 0 then
    ExtraireBonus := Copy(valeur, posDebut + 1, Length(valeur) - posDebut - 1) // Extrait le bonus
  else
    ExtraireBonus:= ''; // Pas de bonus trouvé
end;










function ComparerBonus(const valeur1, valeur2: string): Integer;
var
  bonus1, bonus2: string;
begin
  // Extraire les bonus des deux valeurs
  bonus1 := ExtraireBonus(valeur1);
  bonus2 := ExtraireBonus(valeur2);

  // Comparer les bonus
  if bonus1 < bonus2 then
    ComparerBonus := -1  
  else if bonus1 > bonus2 then
    ComparerBonus := 1
  else
    ComparerBonus := 0; 
end;

function FusionnerListesParBonus(gauche, droite: PCellule): PCellule;
var
  resultat: PCellule;
begin
if gauche = nil then
  FusionnerListesParBonus:=(droite)
else if droite = nil then
  FusionnerListesParBonus:=(gauche)
else

begin

  // Comparer les bonus des deux nœuds
  if ComparerBonus(gauche^.valeur, droite^.valeur) <= 0 then
  begin
    resultat := gauche; 
    resultat^.suivant := FusionnerListesParBonus(gauche^.suivant, droite);
  end
  else
  begin
    resultat := droite; 
    resultat^.suivant := FusionnerListesParBonus(gauche, droite^.suivant);
  end;

  FusionnerListesParBonus:=(resultat);
end;
end;
procedure TriFusionParBonus(var tete: PCellule);
var
  gauche, droite: PCellule;
begin
  if (tete = nil) or (tete^.suivant = nil) then
    Exit;

  // Diviser la liste en deux sous-listes
  DiviserListe(tete, droite, gauche); 

  // Appliquer le tri récursivement
  TriFusionParBonus(gauche);
  TriFusionParBonus(droite);

  // Fusionner les listes triées
  tete := FusionnerListesParBonus(gauche, droite);
end;
end.