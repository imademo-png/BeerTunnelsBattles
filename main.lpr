program main;
{$mode objfpc}{$H+}
uses
  classes,sysutils,
  //Unités d'IHM
  GestionEcran in 'GestionEcran.pas',
  unitVueMenuPrincipal in 'unitVueMenuPrincipal.pas',
  unitVueCreationPerso in 'unitVueCreationPerso.pas',
  unitVueIHM in 'unitVueIHM.pas',
  unitVueChambre in 'unitVueChambre.pas',
  unitVueForge in 'unitVueForge.pas',
  unitVueMarchand in 'unitVueMarchand.pas',
  unitVueContrat in 'unitVueContrat.pas',
  unitVueLieu in 'unitVueLieu.pas',
  unitVueVille in 'unitVueVille.pas',
  unitVueTaverne in 'unitVueTaverne.pas',
  unitVueASCII in 'unitVueASCII.pas',
  unitVueCombat in 'unitVueCombat.pas',
  //Unités Métier
  unitMetierPersonnage in 'unitMetierPersonnage.pas',
  unitMetierEquipement in 'unitMetierEquipement.pas',
  unitMetierInventaire in 'unitMetierInventaire.pas',
  unitMetierContrat in 'unitMetierContrat.pas',
  unitMetierMonstre in 'unitMetierMonstre.pas';
begin 
  randomize;
  unitVueLieu.Hub();
end.