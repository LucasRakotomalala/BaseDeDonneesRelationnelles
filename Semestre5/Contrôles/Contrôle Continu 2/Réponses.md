# Bases de données relationnelles
## Contrôle Continu n°2 - Mes réponses
-----------------

### Question 1 :
Identifiants et noms des clients, ainsi que leur nombre de comptes, et la somme des soldes de leur comptes (agrégat SUM).
Un client sans compte ne doit pas apparaitre dans le résultat.
Trier par identifiant de client.
La troisième colonne sera titrée "Nombre de comptes" et la derniere "Total des comptes".

`SELECT DISTINCT client.idCl,
client.nom,
count(compte.idCl) AS "Nombre de comptes",
sum(compte.solde) AS "Total des comptes"
FROM client
JOIN compte ON compte.idCl = client.idCl
GROUP BY 1, 2;`

-----------------

### Question 2 :
Donner toutes les agences avec leurs comptes en affichant :
- identifiant de l'agence
- nom de l'agence
- numero de compte
- solde
Une agence sans compte ne doit pas apparaitre dans le résultat.
Trier par identifiant d'agence , puis par numéro de compte.
La deuxième colonne sera intitulée "Nom de l'agence".

`SELECT DISTINCT
agence.idA,
agence.nom AS "Nom de l'agence",
compte.numCo,
compte.solde
FROM compte
JOIN agence ON compte.idA = agence.idA
ORDER BY agence.idA, compte.numCo;`

-----------------

### Question 3 :
Pour tous les couples d'agences homonymes, afficher sur trois colonnes intitulées nom, agence1, agence2 leur nom et leurs deux identifiants
On ne dupliquera pas d'information.

On ordonnera par nom, agence1, agence2.

`SELECT DISTINCT
agence1.nom,
agence1.idA AS "agence1",
agence2.idA AS "agence2"
FROM agence AS agence1
INNER JOIN agence AS agence2
WHERE agence1.nom = agence2.nom AND agence1.idA < agence2.idA
ORDER BY agence1.nom, agence1.idA, agence2.idA;`

-----------------

### Question 4 :
Nom des villes, et nombre d'agences dans la ville, pour toutes les villes ayant au moins une agence.
Trier par nombre d'agences croissant.
La deuxième colonne sera titrée "Nombre d'agences".

`SELECT
agence.ville,
count(*) AS "Nombre d'agences"
FROM agence
GROUP BY agence.ville
ORDER BY 2;`

-----------------

### Question 5 :
Afficher par **ordre décroissant** les identifiants des agences qui n'ont fait aucun prêt (c'est à dire qu'il n'y a aucun emprunt correspondant à cette agence).

`SELECT agence.ida
FROM agence
EXCEPT
SELECT agence.idA
FROM agence
JOIN emprunt ON emprunt.idA = agence.idA
ORDER BY agence.idA DESC;`

-----------------

### Question 6 :
Identifiants et nom des clients n'ayant d'emprunt que dans des agences hors de leur propre ville classé par identifiant client, puis nom du client.
Un client sans emprunt doit apparaître dans le résultat.

`SELECT client.idCl,
client.nom
FROM client
EXCEPT
SELECT client.idCl,
client.nom
FROM client
JOIN emprunt ON client.idCl = emprunt.idCl
JOIN agence ON emprunt.idA = agence.idA
WHERE agence.ville = client.ville
ORDER BY 1, 2;`

-----------------

### Question 7 :
Identifiants classés par ordre croissant des clients ayant un compte dans une agence qui n'est pas située dans leur ville.

`SELECT DISTINCT client.idCl
FROM client
JOIN compte ON compte.idCl = client.idCl
JOIN agence ON agence.idA = compte.idA
WHERE client.ville <> agence.ville
ORDER BY 1;`

-----------------

### Question 8 :
Identifiants des agences qui ont un client dans la ville V1 et un client dans la ville V3 , triés par ordre croissant.

**Réponse non trouvée**

-----------------

### Question 9 :
Numéro de compte et identifiant d'agence pour tous les comptes, classés par identifiant d'agence puis par numéro de compte.

`SELECT compte.numCo, compte.idA
FROM compte
ORDER BY 2, 1;`

-----------------

### Question 10 :
Identifiant, nom et ville du ou des clients ayant le moins d'argent en tout sur leur comptes (dont la somme des soldes est minimal).
Ordonner par identifiant.
On rappelle l'existence de l'agrégat SUM.

**Réponse non trouvée**

-----------------

### Question 11 :
Trouver les identifiants des clients qui ont un compte dans chaque ville ou il y a au moins une agence.
On classera les identifiants par ordre croissant.

**Réponse non trouvée**
