unit unitVueTaverne;
{$codepage utf8}
{$mode objfpc}{$H+}

interface
uses
  unitVueLieu,unitTriFusion,unitStructures;

//Fonctions et procédures
//Affichage de la taverne
function  mainTaverne() : Lieu;


type                  // Liste DC de pages
PPage = ^Page;
Page = record
numero: integer;    // Numéro de la page
suivant: PPage;
precedent: PPage;
end;

TListePages = record    
courante: PPage;      
debut: PPage;
fin: PPage;
end;


procedure effacerTexte;
procedure ajouterPage(var liste: TListePages; numPage: Integer);      // Pour ajouter une page à la liste
procedure affichageRecettes(pagecourante : integer; liste: PCellule; pagestotal : integer);   // Pour afficher les recettes
procedure avancerPage(var liste: TListePages);                  // Pour avancer d'une page
procedure reculerPage(var liste: TListePages);                  // Pour reculer d'une page
procedure ajouter(var liste: PCellule; valeur: String);       // Pour ajouter une recette à la liste
implementation
uses
  SysUtils, Classes,GestionEcran,unitVueIHM,unitMetierPersonnage;

procedure ajouterPage(var liste: TListePages; numPage: Integer);
var
  nouvPage: PPage;
begin
  New(nouvPage);
  nouvPage^.numero := numPage;
  nouvPage^.suivant := NIL;
  nouvPage^.precedent := liste.fin;

  if liste.fin <> NIL then
    liste.fin^.suivant := nouvPage;
  liste.fin := nouvPage;

  if liste.debut = NIL then
    liste.debut := nouvPage;
end;

procedure avancerPage(var liste: TListePages);
begin
  if liste.courante <> NIL then
    liste.courante := liste.courante^.suivant;
end;

procedure reculerPage(var liste: TListePages);
begin
  if liste.courante <> NIL then
    liste.courante := liste.courante^.precedent;
end;

procedure ajouter(var liste: PCellule; valeur: String);
var
p: PCellule;
begin
new(p);
p^.valeur := valeur;
p^.suivant := liste;
liste := p;
end;

procedure afficher(liste: PCellule);
var
p: PCellule;
begin
TriFusion(liste);
p := liste;
while p <> NIL do
begin
write(p^.valeur);
p := p^.suivant;
end;
end;

procedure affichageRecettes(pagecourante : integer; liste: PCellule; pagestotal : integer);
var
i : integer;
j : integer;
id : integer;
p: PCellule;
begin
id := 1;
TriFusion(liste);
p := liste;
for i := 9 to 16 do
begin
if pagecourante <> 1 then                    // Si on est pas à la première page alors on avance du numero de page actuel multiplié par 7 le tout -1 pour afficher une autre page
begin
  for j := 1 to (pagecourante * 7) - 1 do
  begin
    p := p^.suivant;
  end;
  if id > 8 then id := 1;     // a chaque page remettre l'identifiant a 1
    deplacerCurseurXY(30,i);write(id,' / ',p^.valeur);
    id := id + 1;
    p := p^.suivant;
end
else
begin
  if id > 8 then id := 1;     // a chaque page remettre l'identifiant a 1
  deplacerCurseurXY(30,i);write(id,' / ',p^.valeur);
  id := id + 1;
  p := p^.suivant;
end;
end;
end;





procedure affichageRecettesTriBonus(pagecourante : integer; liste: PCellule; pagestotal : integer);
var
i : integer;
j : integer;
p: PCellule;
begin
TriFusionParBonus(liste);
p := liste;
for i := 9 to 16 do                     // ecrire les recette pour des lignes 9 à 16
begin
if pagecourante <> 1 then
begin
  for j := 1 to (pagecourante * 7) - 1 do
  begin
    p := p^.suivant;
  end;
    deplacerCurseurXY(30,i);write(p^.valeur);
    p := p^.suivant;
end
else
begin
  deplacerCurseurXY(30,i);write(p^.valeur);
  p := p^.suivant;
end;
end;
end;




procedure Annecdote();
var 
  numero:integer;
begin
  numero := random(16);
  case numero of
    0 : 
      begin
      couleurTexte(cyan);
      deplacerCurseurXY(29,16);write('Hé ! Vous voyez l''elfe là-bas, avec son luth à six cordes ? Il s''appelle Alessandor Gildeth,');
      deplacerCurseurXY(29,17);write('et il vient de la majestueuse forêt de Lothlórien. On dit même qu''il serait de la famille de');
      deplacerCurseurXY(29,18);write('Dame Galadriel elle-même.');
      end;
    1 : 
      begin
      couleurTexte(cyan);
      deplacerCurseurXY(29,16);write('Si vous tendez l''oreille le soir, dans le silence des tunnels sombres de la mine, vous enten');
      deplacerCurseurXY(29,17);write('drez peut-être un chant mystérieux. Les mineurs racontent que ce serait l''esprit maudit d''un');
      deplacerCurseurXY(29,18);write('érudit elfe, disparu jadis en ces profondeurs. On raconte qu''il errait à la recherche de ses');
      deplacerCurseurXY(29,19);write('étudiants égarés… et qu''il continue encore aujourd''hui, incapable de trouver ni le repos ni');
      deplacerCurseurXY(29,20);write('ses clés.');
      end;
    2 : 
      begin
      couleurTexte(cyan);
      deplacerCurseurXY(29,16);write('Méfiez-vous du rôdeur assis au fond, là-bas. Vous voyez, celui qui garde la capuche bien bas');
      deplacerCurseurXY(29,17);write('se ? Si vous vous approchez trop, il vous parlera dans une langue étrange. Il appelle ça les');
      deplacerCurseurXY(29,18);write('mathématiques, mais on ne me la fait pas, à moi ! Je sais reconnaître le Noir Parler quand');
      deplacerCurseurXY(29,19);write('je l''entends ! ');
      end;
    3 : 
      begin
      couleurTexte(cyan);
      deplacerCurseurXY(29,16);write('Vous voyez l''humain au fond ? Longue barbe et pull étrange ? Il est à la recherche d''aventu');
      deplacerCurseurXY(29,17);write('riers pour l''aider dans sa quête. Il est à la recherche d''une relique sombre, un vieux manu');
      deplacerCurseurXY(29,18);write('scrit perdu depuis des siècles qui contiendrait les sujets de Rêz''o.');
      end;
  end;
  couleurTexte(white);
end;

//Manger dans la taverne
function mangerTaverne() : Lieu;
var
  selection : integer;
  selectionnom : string;
  choix : integer;
  id : integer;
  choisir : integer;
  i : integer;
  ligne : string;
  lignaffich : integer;
  pagestotal : integer;
  mem : integer;
  FichierRecette: TextFile;
  liste : PCellule;
  pages: TListePages;
begin
  id := 1;        // l'identifiant de la premiere recette est 1
  pages.debut := NIL;
  pages.fin := NIL;
  pages.courante := NIL;
  afficherInterfacePrincipale('Tarverne de la Moria');

    AssignFile(FichierRecette, 'Recettes.txt'); // Remplace par le chemin de ton fichier
  Reset(FichierRecette); // Ouvre le fichier en mode lecture
    i := 0;
    mem :=0;
    pagestotal := 0;
    lignaffich := 11;
    liste := nil;
    while not EOF(FichierRecette) do      // Tant qu'on est pas a la fin du fichier
      begin
      ReadLn(FichierRecette, ligne); // Lit une ligne du fichier

      ajouter(liste,Ligne);
      mem := mem+1;
      if mem = 7 then
      begin
      id := 1;
      mem := 1;
      pagestotal := pagestotal + 1;
      ajouterPage(pages, pagestotal);
      end;
      Inc(i);
      end;
       pages.courante := pages.debut;
  deplacerCurseurXY(63,5);write('Le cuisinier vous proposent :');
    couleurTexte(Cyan);
    deplacerCurseurXY(30,7);write('Plat');
    deplacerCurseurXY(70,7);write('Bonus');  
    couleurTexte(White);
    affichageRecettes( pages.courante^.numero ,liste, pagestotal);
  couleurTexte(White);
  deplacerCurseurXY(45,18);write('Page : ',pages.courante^.numero,' sur ',pagestotal);
  deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?'); //
    deplacerCurseurZoneAction(3);write('     ?/ Commander un plat (entrer son numéro)');  
    deplacerCurseurZoneAction(4);write('     0/ Faire autre chose');   
    deplacerCurseurZoneAction(5);write('     -1/ Aller page suivante');  
    deplacerCurseurZoneAction(6);write('     -2/ Aller page precedente');  
    deplacerCurseurZoneAction(7);write('     -4/ Tri par ordre des bonus');  

  choix := 999;
  while (choix <> 0) do
  begin
    dessinerCadreXY(139,36,145,38,simple,white,black);
    deplacerCurseurXY(142,37);
    readln(choix);
    if choix = -1 then    // Si on veut aller a la page suivante
    begin
        effacerTexte;

        avancerPage(pages);   // On avance d'une page
        affichageRecettes( pages.courante^.numero ,liste, pagestotal);  // On affiche les recettes de la page actuelle
        while choix = -1 do 
        begin
        deplacerCurseurXY(45,18);write('Page : ',pages.courante^.numero,' sur ',pagestotal);
          dessinerCadreXY(139,36,145,38,simple,white,black);
          deplacerCurseurXY(142,37);
        readln(choix);
        if choix = -1 then
        begin
        effacerTexte;

        avancerPage(pages);
        affichageRecettes( pages.courante^.numero ,liste, pagestotal);
        end;
        end;
    end;
        if choix = -2 then // Si on veut aller a la page precedente
    begin
 

        effacerTexte;
 
        reculerPage(pages);   // On recule d'une page
        affichageRecettes( pages.courante^.numero ,liste, pagestotal);    // On affiche les recettes de la page actuelle
        while choix = -2 do
        begin
        deplacerCurseurXY(45,18);write('Page : ',pages.courante^.numero,' sur ',pagestotal);
          dessinerCadreXY(139,36,145,38,simple,white,black);
          deplacerCurseurXY(142,37);
        readln(choix);
        if choix = -2 then
        begin
        effacerTexte;

        reculerPage(pages);
        affichageRecettes( pages.courante^.numero ,liste, pagestotal);
        end;
        end;
    end;
    if choix = -4 then 
    begin
    effacerTexte;

    affichageRecettesTriBonus( pages.courante^.numero ,liste, pagestotal);
  
    end;
    if (choix > 0) and (choix < 9) then   // Si on a choisi un plat entre le premier et le 8eme de la page
    begin
    selection := choix + ( (pages.courante^.numero -1) * 8);    // On recupere le numero du plat parmi tous
    mem := 0;
    while mem <> selection do   // On parcours la liste jusqu'a arriver au plat choisi
      begin
      mem := mem+1;
      liste:= liste^.suivant;
      end;
      selectionnom := liste^.valeur;    // On recupere le nom du plat
      writeln('Vous avez choisi le plat numero ',selection);    // On affiche le numero du plat choisi
      writeln('Vous avez choisi le plat ',selectionnom);        // On affiche le nom du plat choisi
      if Pos('Critique', selectionnom) > 0 then writeln('Vous avez choisi le buff Critique');   // On affiche le buff du plat choisi 
      if Pos('Regeneration', selectionnom) > 0 then writeln('Vous avez choisi le buff Regeneration');
      if Pos('Force', selectionnom) > 0 then writeln('Vous avez choisi le buff Force');
    end;

  TriFusion(liste);
end;
  mainTaverne();
end;

procedure effacerTexte;
begin
deplacerCurseurXY(30,9);write('                                                                                          ');
deplacerCurseurXY(30,10);write('                                                                                          ');
deplacerCurseurXY(30,11);write('                                                                                          ');
deplacerCurseurXY(30,11);write('                                                                                          ');
deplacerCurseurXY(30,12);write('                                                                                          ');
deplacerCurseurXY(30,13);write('                                                                                          ');
deplacerCurseurXY(30,14);write('                                                                                          ');
deplacerCurseurXY(30,15);write('                                                                                          ');
deplacerCurseurXY(30,16);write('                                                                                          ');
end;

//Boire dans la taverne
function boireTaverne() : Lieu;
begin
  afficherInterfacePrincipale('Tarverne de la Moria');

  deplacerCurseurXY(29,7);write('Le tavernier, un nain au visage buriné par les ans, vous accueille chaleureusement. En enten');
  deplacerCurseurXY(29,8);write('dant votre commande, il éclate d''un rire profond qui résonne comme un écho dans la caverne.');

  couleurTexte(cyan);
  deplacerCurseurXY(29,10);write('Une bière, hein ? Une vraie, brassée ici même dans les caves de la Moria !');

  couleurTexte(white);
  deplacerCurseurXY(29,12);write('Il empoigne une chope massive et la remplit à ras bord, un torrent de mousse débordant sur');
  deplacerCurseurXY(29,13);write('ses doigts. Il la pose devant vous avec un geste expert et s''essuie les mains sur son tab');
  deplacerCurseurXY(29,14);write('lier déjà taché.');

  Annecdote();

  couleurTexte(White);
  deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
  deplacerCurseurZoneAction(3);write('     1/ Finir votre bière');

  case choixMenu(1,1) of
       1 : boireTaverne := TAVERNE; 
  end;                                                                     
end;

//Affichage de la taverne
function  mainTaverne() : Lieu;
begin
  afficherInterfacePrincipale('Tarverne de la Moria');

  deplacerCurseurXY(29,7);write('Vous poussez la lourde porte en bois sculptée, et un souffle d''air tiède chargé d''arômes de');
  deplacerCurseurXY(29,8);write('bière maltée, de ragoût épicé et de tabac nain vient vous accueillir. La lumière vacillante');
  deplacerCurseurXY(29,9);write('des chandeliers et des lanternes enchantées éclaire la vaste salle, creusée à même la roche');
  deplacerCurseurXY(29,10);write('millénaire des Mines de la Moria. Le plafond, soutenu par de majestueuses colonnes sculptées');
  deplacerCurseurXY(29,11);write('d''inscriptions anciennes, semble raconter des histoires oubliées.');

  deplacerCurseurXY(29,13);write('Autour de vous, l''ambiance est festive et chaleureuse. Des mineurs nains en tabliers rient');
  deplacerCurseurXY(29,14);write('bruyamment, levant leurs chopes débordantes, tandis qu''un elfe solitaire gratte une mélodie');
  deplacerCurseurXY(29,15);write('entraînante sur un luth, suscitant des regards amusés. Le crépitement d''un feu généreux dans');
  deplacerCurseurXY(29,16);write('l''âtre en pierre réchauffe l''air et semble adoucir les mines parfois rudes des clients. Dans');
  deplacerCurseurXY(29,17);write('un coin, un groupe d''aventuriers se penche sur une carte, leurs voix basses mêlées de mystère.');

  couleurTexte(White);
  deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
  deplacerCurseurZoneAction(3);write('     1/ Boire une bière');
  deplacerCurseurZoneAction(4);write('     2/ Manger un peu');
  deplacerCurseurZoneAction(5);write('     3/ Quitter la taverne');

  case choixMenu(1,3) of
       1 : mainTaverne := boireTaverne();
       2 : mainTaverne := mangerTaverne();
       3 : mainTaverne := VILLE;  
  end;                                                                   
end;
  

  
end.