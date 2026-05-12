unit unitVueCombat;
{$codepage utf8}
{$mode objfpc}{$H+}

interface
uses unitVueLieu;
 //Affichage des combats
function mainMine() : Lieu;
  
implementation
uses
  SysUtils,GestionEcran,unitVueIHM,unitMetierMonstre,unitMetierInventaire,unitMetierPersonnage,unitMetierContrat;

type
  TtableauMonstres = array of Tmonstre;

var
  monstres : TtableauMonstres;

//Affichage d'un monstre
procedure afficherMonstre(monstre : Tmonstre;numero : integer);
var
  colonne : integer;
  couleur : byte;
begin
  couleur := white;
  if(monstre.sante = 0) then couleur := LightRed;

  colonne := 6;
  if(numero>=3) then colonne:=80;

  dessinerCadreXY(colonne-1,7+7*(numero mod 3),colonne+60,11+7*(numero mod 3),simple,couleur,Black);
  deplacerCurseurXY(colonne+3,8+7*(numero mod 3));write(numero+1,'- ',monstreToString(monstre.typeMonstre));
  deplacerCurseurXY(colonne+3,9+7*(numero mod 3)); write('      VIE : ',monstre.sante);
  deplacerCurseurXY(colonne+3,10+7*(numero mod 3));write('     ETAT : ',etatToString(monstre.etat));
  couleurTexte(white);
end;

//Charge les monstres
procedure genererMonstres();
var
  typeMonstre : TtypeMonstre;
  nbMonstre : integer;
  numeroMonstre : integer;
  i : integer;
begin
  nbMonstre := 0;
  for typeMonstre := Low(TtypeMonstre) to High(TtypeMonstre) do nbMonstre += getContratActif().monstres[typeMonstre];

  SetLength(monstres,nbMonstre);
  numeroMonstre := 0;
  for typeMonstre := Low(TtypeMonstre) to High(TtypeMonstre) do
  begin
    for i:=1 to getContratActif().monstres[typeMonstre] do
    begin
      monstres[numeroMonstre] := newMonstre(typeMonstre);
      numeroMonstre += 1;
    end;
  end;

end;

//Affichage de l'IHM du combat
procedure affichageIHMCombat();
var
  i:integer;
begin
  afficherInterfacePrincipale('Dans les profondeurs...'); 
  deplacerCurseurXY(63,5);write('Des montres vous attaquent !'); 

  for i:= 0 to Length(monstres)-1 do afficherMonstre(monstres[i],i);

end;

//Renvoie le nombre de monstre en vie
function nombreMonstresEnVie() : integer;
var 
  i:integer;
  nombre : integer;
begin
  nombre := 0;
  for i:=0 to Length(monstres)-1 do
  begin
    if(monstres[i].sante > 0) then nombre += 1;
  end;
  nombreMonstresEnVie := nombre;
end;

//Affichage du tour du joueur
procedure TourDuJoueur();
var 
  choix : integer;
  i : integer;
  degat : integer;
  alea : integer;
begin

  affichageIHMCombat();

  couleurTexte(White);
  deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
  deplacerCurseurZoneAction(3);write('     ?/ Attaquer un monstre');
  deplacerCurseurZoneAction(4);write('     ',Length(monstres)+1,'/ Prendre une potion');
  deplacerCurseurZoneAction(5);write('     ',Length(monstres)+2,'/ Lancer une bombe');

  choix := ChoixMenu(1,Length(monstres)+2);
  //Prise d'une potion
  if(choix = Length(monstres)+1) then
  begin
    if(quantiteObjet(POTION)>0) then
    begin
      afficherMessage('Vous buvez une potion !');
      consommerObjet(POTION);
      soignerPersonnage();
    end
    else afficherMessageErreur('Vous cherchez sans succès une potion dans votre sac');
    readln;
  end
  //Utilisation d'une bombe
  else if(choix = Length(monstres)+2) then
  begin
    if(quantiteObjet(BOMBE)>0) then
    begin
      afficherMessage('Vous lancez une bombe sur les monstres !');
      consommerObjet(BOMBE);
      for i:= 0 to Length(monstres)-1 do etourdirMonstre(monstres[i]);
    end
    else afficherMessageErreur('Vous cherchez sans succès une bombe dans votre sac');
    readln;
  end
  //Attaque d'un monstre
  else
  begin
    degat := attaquer(monstres[choix-1]);
    affichageIHMCombat();
    if(degat > 0) then afficherMessage('Vous attaquez le monstre ('+monstreToString(monstres[choix-1].typeMonstre)+'). Il perd '+IntToStr(degat)+' PV')
    else if (degat = 0) then afficherMessageErreur('Vous attaquez le monstre ('+monstreToString(monstres[choix-1].typeMonstre)+') mais cela ne le blesse pas.')
    else if (degat = -1) then afficherMessageErreur('Vous attaquez le monstre ('+monstreToString(monstres[choix-1].typeMonstre)+') mais il est déjà mort...');
    readln;
  end;
end;

//Tour des monstres
procedure TourDesMonstres();
var
  i : integer;
  degat : integer;
  pos : integer;
begin

  affichageIHMCombat();
  deplacerCurseurZoneAction(1);write('Les monstres vous attaquent !');
  pos := 3;
  for i:=0 to Length(monstres)-1 do
  begin
    if(monstres[i].sante>0) then
    begin
      deplacerCurseurZoneAction(pos);
      if(monstres[i].etat <> NORMAL) then write('Le monstre ('+monstreToString(monstres[i].typeMonstre)+') ne peut pas attaquer')
      else
      begin
        degat := attaqueMonstre(monstres[i]);
        if(degat > 0) then write('Le monstre ('+monstreToString(monstres[i].typeMonstre)+') vous attaque et vous fait perdre '+IntToStr(degat)+' PV')
        else if(degat = 0) then write('Le monstre ('+monstreToString(monstres[i].typeMonstre)+') vous attaque mais votre armure vous protège');
      end;
      evolutionEtat(monstres[i]);
      pos += 1;
    end;
  end;
  if (getSanteePersonnage()>0) AND (getBonusPersonnage() = REGENERATION) then regen();
  couleurTexte(White);
  readln;
end;

//Mort du joueur
function Mort() : Lieu;
begin
  affichageIHMCombat();
  deplacerCurseurZoneAction(1);write('Vous ressentez une vive douleur dans tout le corps et vous vous effondrez sur le sol.');
  deplacerCurseurZoneAction(2);write('Le monde s''obscurcit tout autour de vous, une dernière fois...');
  deplacerCurseurZoneAction(3);write('Vous êtes mort !');
  readln;
  Mort := LOGO;
end;

//Victoire du joueur
function Victoire() : Lieu;
begin
  affichageIHMCombat();
  deplacerCurseurZoneAction(1);write('Vous terrassez votre dernière ennemi et fouillez les cadavres à la recherche de ressources.');
  deplacerCurseurZoneAction(2);write('Votre contrat terminé, vous sortez des tunnels de la mine et allez toucher votre prime.');
  readln;
  finirContratActif();
  Victoire := VILLE;
end;

 //Affichage des combats
function mainMine() : Lieu;
var 
  estFini :boolean;
  phase : integer;
begin  
  genererMonstres();
  estFini := false;
  phase := 0;

  while not(estFini) do
  begin
    case phase of
      0 : TourDuJoueur();
      1 : TourDesMonstres();
    end;
    phase := (phase + 1) mod 2;
    //Mort
    if(getSanteePersonnage() = 0) then
    begin
      estFini := true;
      mainMine := Mort();
    end
    //Victoire
    else if nombreMonstresEnVie() = 0 then
    begin
      estFini := true;
      mainMine := Victoire();
    end;
  end;
end; 

  
end.