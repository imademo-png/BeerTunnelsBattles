unit unitSauvegarde;
{$codepage utf8}
{$mode objfpc}{$H+}

interface

uses
  unitVueLieu;

function mainSauvegarde() : Lieu;

implementation

uses
  SysUtils, Classes, GestionEcran, unitVueIHM, unitVueASCII, unitMetierPersonnage, 
  unitMetierEquipement, unitVueChambre, unitMetierInventaire;

var
  FileVar: TextFile;  // Fichier de sauvegarde
  NomDuPersonnage: string;  // Nom temporaire du personnage
  Line: string;  // Ligne temporaire pour lecture
  taille: Integer;  // Taille du personnage
  buff: string;  // Buff temporaire
  TailleStr: string;
  nom: string;
  Nom_Fini: boolean;
  Taille_Fini: boolean;

  genreDuPersonnage: Tgenre;  // Genre du personnage

function mainSauvegarde() : Lieu;
begin
  // Vérifie si le fichier de sauvegarde existe
  if not FileExists('Sauvegarde.txt') then
  begin
    deplacerCurseurXY(146,37); Write('Vous avez pas de Sauvegarde.');
    exit;
  end;

  // Lecture du nom du personnage
  AssignFile(FileVar, 'Sauvegarde.txt');
  {$I+}
  try
    Reset(FileVar);  // Ouvre le fichier
    while not Eof(FileVar) do
    begin
      ReadLn(FileVar, Line);  // Lit une ligne
      if Pos('Nom : ', Line) = 1 then
      begin
        setNomPersonnage(Copy(Line, 7, Length(Line) - 5));  // Définit le nom
      end;
    end;
    CloseFile(FileVar);  // Ferme le fichier
  except
    on E: EInOutError do
      Writeln('Erreur lors de l''ouverture du fichier : ', E.Message);
  end;

  // Lecture du genre du personnage
  AssignFile(FileVar, 'Sauvegarde.txt');
  {$I+}
  try
    Reset(FileVar);
    while not Eof(FileVar) do
    begin
      ReadLn(FileVar, Line);
      if Pos('Femme', Line) = 9 then
        setGenrePersonnage(FEMININ)
      else if Pos('Homme', Line) = 9 then
        setGenrePersonnage(MASCULIN)
      else if Pos('Autre', Line) = 9 then
        setGenrePersonnage(AUTRE);
    end;
    CloseFile(FileVar);
  except
    on E: EInOutError do
      Writeln('Erreur lors de l''ouverture du fichier : ', E.Message);
  end;

  // Lecture de la taille du personnage
  AssignFile(FileVar, 'Sauvegarde.txt');
  {$I+}
  try
    Reset(FileVar);
    while not Eof(FileVar) do
    begin
      ReadLn(FileVar, Line);
      if Pos('Taille : ', Line) = 1 then
      begin
        taille := StrtoInt(Copy(Line, 9, Length(Line) - 5));  // Extrait la taille
        setTaillePersonnage(taille);
      end;
    end;
    CloseFile(FileVar);
  except
    on E: EInOutError do
      Writeln('Erreur lors de l''ouverture du fichier : ', E.Message);
  end;

  // Lecture de la santé actuelle
  AssignFile(FileVar, 'Sauvegarde.txt');
  {$I+}
  try
    Reset(FileVar);
    while not Eof(FileVar) do
    begin
      ReadLn(FileVar, Line);
      if Pos('Sante : ', Line) = 1 then
        setSanteePersonnage(StrtoInt(Copy(Line, 9, Length(Line) - 5)));
    end;
    CloseFile(FileVar);
  except
    on E: EInOutError do
      Writeln('Erreur lors de l''ouverture du fichier : ', E.Message);
  end;

  // Lecture de la santé maximale
  AssignFile(FileVar, 'Sauvegarde.txt');
  {$I+}
  try
    Reset(FileVar);
    while not Eof(FileVar) do
    begin
      ReadLn(FileVar, Line);
      if Pos('Sante Max : ', Line) = 1 then
        setSanteeMaxPersonnage(StrToInt(Copy(Line, Length('Sante Max : ') + 1, Length(Line) - Length('Sante Max : '))));
    end;
    CloseFile(FileVar);
  except
    on E: EInOutError do
      Writeln('Erreur lors de l''ouverture du fichier : ', E.Message);
  end;

  // Lecture des ressources : argent, cuivre, fer, charbon, mithril
  AssignFile(FileVar, 'Sauvegarde.txt');
  {$I+}
  try
    Reset(FileVar);
    while not Eof(FileVar) do
    begin
      ReadLn(FileVar, Line);
      if Pos('Argent : ', Line) = 1 then
        ajouterResources(MINOR, StrtoInt(Copy(Line, 9, Length(Line) - 5)))
      else if Pos('cuivre : ', Line) = 1 then
        ajouterResources(MINCUIVRE, StrtoInt(Copy(Line, 10, Length(Line) - 5)))
      else if Pos('Fer : ', Line) = 1 then
        ajouterResources(MINFER, StrtoInt(Copy(Line, 6, Length(Line) - 5)))
      else if Pos('Charbon : ', Line) = 1 then
        ajouterResources(MINCHARBON, StrtoInt(Copy(Line, 10, Length(Line) - 5)))
      else if Pos('Mithril : ', Line) = 1 then
        ajouterResources(MINMITHRIL, StrtoInt(Copy(Line, 10, Length(Line) - 5)));
    end;
    CloseFile(FileVar);
  except
    on E: EInOutError do
      Writeln('Erreur lors de l''ouverture du fichier : ', E.Message);
  end;

  // Lecture des objets : potions, bombes
  AssignFile(FileVar, 'Sauvegarde.txt');
  {$I+}
  try
    Reset(FileVar);
    while not Eof(FileVar) do
    begin
      ReadLn(FileVar, Line);
      if Pos('Potions : ', Line) = 1 then
        ajouterObjets(POTION, StrtoInt(Copy(Line, 10, Length(Line) - 5)))
      else if Pos('Bombes : ', Line) = 1 then
        ajouterObjets(BOMBE, StrtoInt(Copy(Line, 9, Length(Line) - 5)));
    end;
    CloseFile(FileVar);
  except
    on E: EInOutError do
      Writeln('Erreur lors de l''ouverture du fichier : ', E.Message);
  end;

  // Lecture du buff
  AssignFile(FileVar, 'Sauvegarde.txt');
  {$I+}
  try
    Reset(FileVar);
    while not Eof(FileVar) do
    begin
      ReadLn(FileVar, Line);
      if Pos('Buff : ', Line) = 1 then
      begin
        if Pos('FORCE', Line) = 8 then
          setBuffPersonnage(FORCE)
        else if Pos('AUCUNBONUS', Line) = 8 then
          setBuffPersonnage(AUCUNBONUS)
        else if Pos('REGENERATION', Line) = 8 then
          setBuffPersonnage(REGENERATION)
        else if Pos('CRITIQUE', Line) = 8 then
          setBuffPersonnage(CRITIQUE);
      end;
    end;
    CloseFile(FileVar);
  except
    on E: EInOutError do
      Writeln('Erreur lors de l''ouverture du fichier : ', E.Message);
  end;

  // Retour à la chambre après la lecture
  mainSauvegarde := mainChambre();
end;

end.
