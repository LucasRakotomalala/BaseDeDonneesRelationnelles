# Bases de donnees relationnelles
## TP1 - Interrogation de données (SQL)

### Question 1 :
Tout sur les pays
`SELECT *
FROM pays;`

### Question 2 :
Pareil mais ordonné sur les `noms`.

`SELECT *
FROM pays
ORDER BY nom;`


### Question 3 :
Toutes les marques ordonnées par nom, classe, pays.

`SELECT marque.nom, marque.classe, marque.pays
FROM marque
ORDER BY 3,2,1;`

### Question 4 :
Afficher les propriétaires associés aux marques qu'ils possèdent.

`SELECT
	societe.nom as NomSociete,
    societe.pays as PaysSociete,
    marque.nom as NomMarque,
    marque.pays as PaysMarque,
    marque.classe as ClasseMarque
    FROM marque
JOIN societe ON marque.prop = societe.id
ORDER BY societe.id, marque.id;`

### Question 5 :
On cherche a détecter une information incohérente en affichant les marques vendues avant leur enregistrement. Les réponses seront ordonnées par classe, puis par nom puis par pays. Les colonnes restent dans l'ordre nom, pays , classe.

`SELECT distinct marque.nom,  marque.pays, marque.classe
FROM (marque JOIN enr ON marque.id = enr.marque)
JOIN vente ON enr.marque = vente.marque
WHERE vente.date_vente < enr.date_enr
ORDER BY 3,1,2;`

### Question 6 :
Nom, pays et classe des marques non enregistrées, classées par pays, nom et classe.

`SELECT marque.nom, marque.pays, marque.classe
FROM marque
EXCEPT
SELECT marque.nom, marque.pays, marque.classe
FROM marque
INNER JOIN enr ON marque.id = enr.marque
ORDER BY 2,1,3;`


### Question 7 :
Les couples de marques de même nom et de même classe dans des pays différents et avec 
des propriétaires différents
Les entetes de colonnes seront :
	nom (commun aux deux marques)
	classe (commune aux deux marques)
	pays_1 (code du pays de la première marque)
	prop_1 (identifiant du propriétaire de la première marque)
	pays_2 (code du pays de la deuxième marque)
	prop_2 (identifiant du propriétaire de la deuxième marque)

Ordonner les résultats par nom, classe, pays_1,prop_1,pays_2, prop_2.

`SELECT m1.nom as nom,
	m1.classe as classe,
	m1.pays as pays_1,
	m1.prop as prop_1,
	m2.pays as pays_2,
	m2.prop as prop_2
	FROM marque as m1
INNER JOIN marque as m2 ON m1.nom = m2.nom and m1.classe = m2.classe
WHERE m1.pays < m2.pays and m1.prop <> m2.prop
ORDER BY 1,2,3,4,5;`

### Question 8 :

Trouver si elles existent les marques qui ne respectent pas la contrainte: le pays d'une marque doit être le même que celui de son propriétaire.

Colonnes à afficher :
	nom de la marque
	classe  de la marque
	paysM de la marque
	paysS de la societe

Ordonner par nom, classe , PaysM,  PaysS.

`SELECT marque.nom, marque.classe,
	marque.pays as paysM,
	societe.pays as paysS
FROM marque
JOIN societe ON marque.prop = societe.id
WHERE marque.pays <> societe.pays
ORDER BY 1,2,3;`

### Question 9 :

Donnez si elles existent les marques qui violent la contrainte suivante:
Le pays d'enregistrement d'une marque doit être le pays de la marque.

`SELECT
	marque.nom as nom,
	marque.classe as classe,
	marque.pays as paysMarque,
	enr.pays as paysEnr
	FROM marque JOIN enr ON marque.id = enr.marque
WHERE marque.pays <> enr.pays
ORDER BY 1,2,3;`

### Question 10 :

Les sociétés qui possèdent des marques qui ne sont pas toutes enregistrées, classées par nom puis par pays.

`SELECT distinct societe.nom, societe.pays
FROM societe JOIN marque ON societe.id = marque.prop
WHERE marque.id NOT IN (SELECT enr.marque
FROM enr)
ORDER BY 1,2;`

### Question 11 :

Les propriétaires qui ne possèdent que des marques enregistrées,
ordonnés par nom puis par pays.
Un propriétaire est une société qui possède au moins une marque

Les entêtes de colonnes doivent être nom et pays et l'ordre se fait sur nom puis pays.

`SELECT distinct societe.nom, societe.pays
FROM societe JOIN marque ON societe.id = marque.prop
WHERE marque.id IN (SELECT enr.marque
FROM enr)
and
societe.id NOT IN
    (SELECT societe.id
    FROM societe JOIN marque ON societe.id = marque.prop
     WHERE marque.id NOT IN (SELECT enr.marque
     FROM enr)
    )
ORDER BY 1,2;`

### Question 12 :

Trouvez si elles existent les marques qui ne respectent pas la contrainte :
le vendeur d'une marque doit être le déposant s'il s'agit d'une première vente
de la marque.

`SELECT
	V.marque,
	V.vendeur,
	E1.deposant,
	V.date_vente
FROM  vente V
JOIN enr E1 ON V.marque=E1.marque
WHERE    
    -- V est la première vente : il n'existe pas de vente antérieure 
    NOT EXISTS
    (SELECT * FROM  vente  V1
    WHERE
    V1.marque=V.marque
    AND
    V1.date_vente < V.date_vente
    ) 
AND
    -- ON suppose qu'il n'y a qu'un dépot par marque,
    -- donc E1 est l'unique dépot de la marque vendue par V
    E1.deposant <> V.vendeur
ORDER BY V.marque;`

**OU**

`SELECT
	V.marque,
	V.vendeur,
	E1.deposant,
	V.date_vente
FROM  vente V
JOIN enr E1 ON V.marque=E1.marque
WHERE    
    -- V est la première vente : il n'existe pas de vente antérieure 
    V.date_vente =
    (SELECT Min(V1.date_vente)  FROM  vente  V1
    WHERE  V1.marque=V.marque
    ) 
AND
    -- ON suppose qu'il n'y a qu'un dépot par marque,
    -- donc E1 est l'unique dépot de la marque vendue par V
    E1.deposant <> V.vendeur
ORDER BY V.marque;`



### Question 13 :

On suppose qu'il y a au moins une marque dans chaque classe. Pour chaque classe (identifiée par son numéro), affichez le nombre de marques de la classe.
Classer les résultats par ordre décroissant des numéros de classe.
La colonne qui contient le nombre de marques devra s'appeler "Nombre de Marques".

`SELECT classe, count(*) AS "Nombre de Marques"
FROM marque
GROUP BY classe
ORDER BY classe desc;`

### Question 14 :
Pour chaque classe (identifiée par son numéro) le nombre de pays
dans lesquels il y a au moins une marque de la classe.

Classer par ordre croissant des numéros de classe.
La colonne qui affiche le nombre de pays devra s'appeler "Nombre de Pays".

`SELECT
	classe,
	count(distinct pays) AS  "Nombre de Pays"
FROM marque
GROUP BY classe
ORDER BY classe;`

### Question 15 : Les sociétés qui sont propriètaires d'au moins une marque, avec le nombre de marques dont elles sont propriétaires.

Les sociétés seront classèes par ordre alphabéÈtique sur leur nom.
Entête des colonnes attendus :
	nom
	pays
	"Nombre de Marques"

`SELECT
	societe.nom,
    societe.pays,
    count(distinct marque.id) AS "Nombre de Marques"
FROM marque
JOIN societe ON marque.prop = societe.id
GROUP BY societe.id , societe.nom, societe.pays
ORDER BY societe.nom;`


### Question 16 : Les sociétés qui ne possèdent aucune marque.

Entêtes de colonne :
	nom 
	pays

Classer les réponses par pays puis par nom de société.

`SELECT societe.nom, societe.pays
FROM societe
EXCEPT
SELECT societe.nom, societe.pays
FROM marque
JOIN societe ON marque.prop = societe.id
ORDER BY 2,1;`



### Question 17 :

Trouver si elles existent les ventes qui ne respectent pas la contrainte :
Le vendeur doit être l'acquereur de la vente precedente.

On affichera :

- l'identifiant de l'acquereur de la vente precedente
- l'identifiant du vendeur
- l'identifiant de la marque
- la date de la vente

Les lignes seront classées selon les identifiants de marque puis les dates.

`SELECT
        VPred.acquereur,
        V.vendeur,
        V.marque,
        V.date_vente
FROM vente VPred
JOIN vente V ON V.marque=VPred.marque
WHERE
    -- VPred est une vente antérieure à V
    VPred.date_vente < V.date_vente
    AND
    -- VPred est la vente précédant immédiatement V
    NOT EXISTS
    (SELECT * FROM  vente  V1
    WHERE
		V1.marque=V.marque
		AND V1.date_vente < V.date_vente
		AND VPred.date_vente < V1.date_vente
    )
    AND
        -- l'acquereur de VPred n'est pas le vendeur de V
    VPred.acquereur <> V.vendeur
ORDER BY V.marque, V.date_vente;`

**OU**

`SELECT
	VPred.acquereur,
	V.vendeur,
	V.marque,
	V.date_vente
FROM vente VPred
JOIN vente V ON V.marque=VPred.marque
WHERE
    -- VPred est la vente immédiatement antérieure à V
    VPred.date_vente = (SELECT MAX(V2.date_vente)
                                         FROM  vente V2
                                        WHERE  V2.date_vente < V.date_vente
                                         AND V2.marque=V.marque)
    AND
        -- l'acquereur de VPred n'est pas le vendeur de V
    VPred.acquereur <> V.vendeur
ORDER BY V.marque, V.date_vente;`

### Question 18 :

Afficher pour chaque  classe , et chaque  propriétaire le nombre de marque possédé par
le propriétaire dans la classe.

Entête des colonnes du résultat attendu :
    classe
    prop
    NB

Ordonner par classe, prop

`SELECT
	classe, prop,
	count(*) AS NB
FROM marque
GROUP BY classe, prop
ORDER BY classe;`

### Question 19 : Afficher pour chaque classe, le ou les propriétaires possédant le plus grand nombre  de marques.
Pour cela, créer d'abord une vue qui "nomme"
le résultat de la requête de la question précédente , puis écrire une requête dont l'entete des colonnes du resultat est :

classe
    NB
    nom
    pays

Ordonner par classe.

`DROP VIEW IF EXISTS NBM_proprio;
CREATE view NBM_proprio AS
SELECT
	M.classe,
    M.prop,
    count(*) AS NB
FROM marque M
GROUP BY M.classe, M.prop;
SELECT DISTINCT NBM1.classe,
NBM1.NB,
S.nom,
S.pays
FROM NBM_proprio AS NBM1
JOIN societe S
ON S.id=NBM1.prop
WHERE NBM1.NB = (
            SELECT max(NBM2.NB)
             FROM NBM_proprio AS NBM2 WHERE NBM2.classe=NBM1.classe)
ORDER BY classe;`
