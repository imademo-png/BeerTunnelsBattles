unit unitStructures;

interface

type
  PCellule = ^Cellule;
  Cellule = record
    valeur: string;
    suivant: PCellule;
  end;

implementation
end.
