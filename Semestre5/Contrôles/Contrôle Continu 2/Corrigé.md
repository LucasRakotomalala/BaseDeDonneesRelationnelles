# Bases de données relationnelles
## Contrôle Continu n°2 - Corrigé
-----------------

### Question 1 :
Identifiants et noms des clients, ainsi que leur nombre de comptes, et la somme des soldes de leur comptes (agrégat SUM).
Un client sans compte ne doit pas apparaitre dans le résultat.
Trier par identifiant de client.
La troisième colonne sera titrée "Nombre de comptes" et la derniere "Total des comptes".

`SELECT idCl, 
nom, 
count(numCo) as "Nombre de comptes", 
sum(solde)  as "Total des comptes"
FROM client
JOIN compte
USING(idCl)
GROUP BY idCl, nom
ORDER BY idCl;`

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

`SELECT idA,
nom as "Nom de l'agence",
numCo, 
solde
FROM
agence
JOIN compte
USING(idA)
ORDER BY idA, numCo;`

-----------------

### Question 3 :
Pour tous les couples d'agences homonymes, afficher sur trois colonnes intitulées nom, agence1, agence2 leur nom et leurs deux identifiants
On ne dupliquera pas d'information.

On ordonnera par nom, agence1, agence2.

`SELECT nom,
A1.idA AS agence1,
A2.idA AS agence2
FROM agence A1
JOIN agence A2
USING(nom)
WHERE A1.idA < A2.idA
ORDER BY nom, agence1, agence2;`

-----------------

### Question 4 :
Nom des villes, et nombre d'agences dans la ville, pour toutes les villes ayant au moins une agence.
Trier par nombre d'agences croissant.
La deuxième colonne sera titrée "Nombre d'agences".

`SELECT ville,
count(idA) as "Nombre d'agences" 
FROM agence
GROUP BY ville
ORDER BY "Nombre d'agences";`

-----------------

### Question 5 :
Afficher par **ordre décroissant** les identifiants des agences qui n'ont fait aucun prêt (c'est à dire qu'il n'y a aucun emprunt correspondant à cette agence).

`SELECT idA 
FROM agence 
WHERE idA NOT IN (SELECT idA FROM emprunt) 
ORDER BY idA DESC;`

-----------------

### Question 6 :
Identifiants et nom des clients n'ayant d'emprunt que dans des agences hors de leur propre ville classé par identifiant client, puis nom du client.
Un client sans emprunt doit apparaître dans le résultat.

`SELECT idCl,
nom
FROM client
EXCEPT
SELECT   idCl, client.nom
FROM client
JOIN emprunt USING(idCl)
JOIN agence USING(idA)
WHERE agence.ville = client.ville
ORDER BY 1, 2;`

-----------------

### Question 7 :
Identifiants classés par ordre croissant des clients ayant un compte dans une agence qui n'est pas située dans leur ville.

`SELECT DISTINCT idCl
FROM client
JOIN compte USING(idCl)
JOIN agence USING(idA)
WHERE agence.ville <> client.ville
ORDER BY idCl;`

-----------------

### Question 8 :
Identifiants des agences qui ont un client dans la ville V1 et un client dans la ville V3 , triés par ordre croissant.

`SELECT idA
FROM client 
JOIN compte USING(idCl)
JOIN agence USING(idA)
WHERE client.ville = 'V1'
INTERSECT 
SELECT idA
FROM client 
JOIN compte USING(idCl)
JOIN agence USING(idA)
WHERE client.ville = 'V3'
ORDER BY 1;`

-----------------

### Question 9 :
Numéro de compte et identifiant d'agence pour tous les comptes, classés par identifiant d'agence puis par numéro de compte.

`SELECT numCo,
idA
FROM compte
ORDER BY idA,numCo`

-----------------

### Question 10 :
Identifiant, nom et ville du ou des clients ayant le moins d'argent en tout sur leur comptes (dont la somme des soldes est minimal).
Ordonner par identifiant.
On rappelle l'existence de l'agrégat SUM.

`WITH CC AS
(SELECT idCl, sum(solde) as NB
FROM compte
GROUP BY idCl)
SELECT idCl, nom, ville
FROM client JOIN CC AS CC1
USING(idCl)
WHERE CC1.NB = (SELECT Min(CC2.NB) FROM CC AS CC2)
ORDER BY idCl`

-----------------

### Question 11 :
Trouver les identifiants des clients qui ont un compte dans chaque ville ou il y a au moins une agence.
On classera les identifiants par ordre croissant.

`SELECT idCl
FROM client
EXCEPT
SELECT idCl FROM
(SELECT idCl, agence.ville FROM client, agence
EXCEPT
SELECT idCl, agence.ville FROM compte JOIN agence USING(idA)) AS T`
