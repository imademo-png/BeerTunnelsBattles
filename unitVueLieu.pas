unit unitVueLieu;
{$mode objfpc}{$H+}

interface
type
  //Liste des lieux pour le jeu
  lieu = (LOGO,CREATIONPERSO,CHAMBRE,CHAMBREPREMIEREFOIS,FORGE,MARCHAND,CONTRAT,MINE,VILLE,TAVERNE,QUITTER,CHARGER);

//Fonctions et procédures
//Hub du jeu (lance les différents lieux)
procedure Hub();


implementation
uses
  SysUtils, Classes,unitVueMenuPrincipal,unitVueTaverne,unitVueChambre,unitVueContrat,unitVueCreationPerso,unitVueForge,unitVueMarchand,unitVueVille,unitVueCombat,unitSauvegarde;
  
//Hub du jeu (lance les différents lieux)
procedure Hub();
var
  lieuActuel : Lieu;
begin
  lieuActuel := LOGO;

  while(lieuActuel <> QUITTER) do
  begin
    case lieuActuel of
      LOGO : lieuActuel := mainLogo();
      CREATIONPERSO : lieuActuel := mainCreationPerso();
      CHAMBREPREMIEREFOIS : lieuActuel := mainChambrePremiereFois();
      CHAMBRE : lieuActuel := mainChambre();
      VILLE : lieuActuel := mainVille();
      TAVERNE : lieuActuel := mainTaverne();
      FORGE : lieuActuel := mainForge();
      MARCHAND : lieuActuel := mainMarchand('');
      CONTRAT : lieuActuel := mainContrat('');
      MINE : lieuActuel := mainMine();
      CHARGER : lieuActuel :=mainSauvegarde();
    end;
  end;
end;
  
end.