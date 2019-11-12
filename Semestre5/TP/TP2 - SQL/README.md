# Bases de donnees relationnelles
## TP2 - SQL

-----------------

### Question 1 :
Affichez le nom et le prénom de tous les personnages dont le nom contient un 't'
Ordonnez par nom puis par prénom.

    SELECT nom, prenom   
    FROM personne 
    WHERE nom LIKE '%t%'
    ORDER BY nom, prenom;

-----------------

### Question 2 :
Affichez le nom et le prénom de tous les personnages dont le nom ne contient pas de 
t, sans tenir compte des majuscules et des minuscules.

Ordonnez par nom puis prénom.

    SELECT nom, prenom   
    FROM personne 
    WHERE NOT upper(nom)  LIKE '%T%'
    ORDER BY nom, prenom;

-----------------

### Question 3 :
Affichez le nom et le prénom des personnages dont le prénom 
contient un y en deuxième position.

Ordonnez par nom puis par prénom.

    SELECT nom, prenom   
    FROM personne 
    WHERE prenom  LIKE '_y%'
    ORDER BY nom, prenom;

-----------------

### Question 4 :
Afficher les propriétaires associés aux marques qu'ils possèdent.

    SELECT DISTINCT nom, prenom  FROM personne 
    WHERE prenom LIKE '%n%n%' and not prenom LIKE '%nn%'
    ORDER BY nom,prenom;

OU

    SELECT DISTINCT nom,
    prenom
    FROM personne
    WHERE prenom LIKE '%n_%n%'
    ORDER BY 1,2;

-----------------

### Question 5 :
Affichez pour les 39 personnes de la table personnes, leur nom, prénom ainsi le nom et le prénom de leur père.

Les personnages doivent apparaître dans la réponse même si leur père est inconnu ( plus précisément inconnu dans cette table)

Les deux dernières colonnes s'appelleront  "Nom du pere" et "Prenom du pere"

Ordonnez par nom puis prénom.

    SELECT individu.nom, individu.prenom, 
            papa.nom as "Nom du pere", 
            papa.prenom as "Prenom du pere"
    FROM personne as individu 
        LEFT JOIN personne as papa 
        ON individu.pere=papa.numpers
    ORDER BY individu.nom, individu.prenom;

-----------------

### Question 6 :
Afficher pour les 39 personnages de la table personnes, leur nom, prénom ainsi le nom et le prénom de leur grand mère paternelle.

A nouveau tous les personnages doivent apparaître dans la réponse.

Les deux dernières colonnes s'appeleront  "Nom de la grand-mere" et  "Prenom de la grand mere"

    SELECT individu.nom, individu.prenom,  
            grandma.nom as "Nom de la grand-mere" ,
            grandma.prenom as "Prenom de la grand mere"
    FROM personne as individu 
    LEFT JOIN personne as papa
    ON individu.pere=papa.numpers
        LEFT JOIN personne as grandma
        ON papa.mere=grandma.numpers
    ORDER BY individu.nom, individu.prenom;

-----------------

### Question 7 :
Affichez le nom et le prénom des personnages dont on connait le père mais pas le grand père paternel.

Ordonnez par nom puis par prénom.

    SELECT individu.nom, individu.prenom
    FROM personne AS individu
    JOIN personne AS papa
    ON individu.pere=papa.numpers
    WHERE papa.pere is NULL
    ORDER BY individu.nom, individu.prenom;

-----------------

### Question 8 :
Affichez pour tous les personnages dont le père est connu, leur nom, leur prénom, le nom de leur père et celui de leur mère (qui peut être inconnue (null))

Les deux dernières colonnes seront intitulées  "Nom du Père" et  "Nom de la Mère"

Ordonnez par nom puis prénom

    SELECT individu.nom, 
    individu.prenom, 
    papa.nom AS "Nom du Père", 
    mama.nom AS "Nom de la Mère"
    FROM personne as individu
    JOIN personne as papa
    ON individu.pere=papa.numpers
    LEFT JOIN personne as mama
    ON individu.mere =mama.numpers
    ORDER BY individu.nom, individu.prenom;

-----------------

### Question 9 :
Ecrire l'ordre d'insertion de Jaime et Tyron Lannister. Leur père est Tywin Lannister, leur mere Joanna Lannister. Leur numPers doit etre plus grand que tous les numPers déjà présent, mais le plus petit possible. Utilisez des sous requetes pour calculer les entiers à insérer. Après votre ordre d'insertion ajouter la requete SELECT * FROM personne ORDER BY numpers; afin de verifier que vous avez bien inserrer les bons tuples

    insert into personne select max(numPers)+1 , 'Lannister','Jaime', 
    (select papa.numPers from personne as papa 
    where papa.nom='Lannister' and papa.prenom='Tywin'),
    (select mama.numPers from personne as mama 
    where mama.nom='Lannister' and mama.prenom='Joanna')
    from personne ;

    insert into personne select max(numPers)+1 , 'Lannister','Tyron', 
    (select papa.numPers from personne as papa 
    where papa.nom='Lannister' and papa.prenom='Tywin'),
    (select mama.numPers from personne as mama 
    where mama.nom='Lannister' and mama.prenom='Joanna')
    from personne ;
    SELECT * FROM personne ORDER BY numpers;

-----------------

### Question 10 :
A l'aide d'une requête imbriquée affichez le nom et le prénom des personnagse dont le père ou la mère est un Lannister.

Ordonnez par nom puis prénom

    SELECT  nom, prenom 
    FROM personne 
    WHERE pere IN 
        (SELECT papa.numPers 
        FROM personne AS papa 
        WHERE papa.nom ='Lannister')
    UNION
    SELECT nom, prenom 
    FROM personne
    WHERE mere IN
        (SELECT mama.numPers 
        FROM personne AS mama 
        WHERE mama.nom ='Lannister')
    ORDER BY nom,prenom;

-----------------

### Question 11 :
A l'aide d'une requête corrélée affichez le nom et le prénom des personnages dont le père ne porte pas le même nom qu'eux.

On n'affichera pas le nom des personnages dont le père est inconnu.

Ordonnez par nom puis prénom

    SELECT  individu.nom, individu.prenom 
    FROM  personne AS individu  
    WHERE individu.pere NOT in 
        (SELECT papa.numpers 
        FROM personne papa 
        WHERE papa.nom =individu.nom);

-----------------

### Question 12 :
Même question, mais à résoudre avec une jointure.
Ordonnez par nom puis prénom

    SELECT individu.nom, individu.prenom
    FROM personne AS individu  
    JOIN personne AS papa
    ON papa.numpers=individu.pere
    WHERE papa.nom <>individu.nom OR
    (individu.nom is NULL AND papa.nom is NOT NULL) OR
    (individu.nom is NOT NULL AND  papa.nom is NULL)
    ORDER BY individu.nom, individu.prenom;


-----------------

### Question 13 :
Et voici qu'on s'apperçoit que Jaime Lannister figure deux fois dans la table.

Supprimez celui des deux qui a le plus petit numéro de personnage

Vous ferez suivre votre ordre de suppression de

SELECT * from personne;

afin de verifier que tout s'est bien passé

    DELETE FROM personne 
    WHERE numpers = (SELECT min(numpers) 
                    FROM personne
                    WHERE nom='Lannister'
                    AND prenom='Jaime') ; 
                    
    SELECT * from personne;

-----------------

### Question 14 :
Rétablissez la vérité historique, rendez à Jaime Lannister tous less enfants qui sont attribués à Robert Baratheon (avec des sous requêtes bien sur)

Vous ferez suivre votre requête de l'ordre

SELECT * FROM personne;

afin de verifier que votre mise à jour a bien été effectuée

    UPDATE personne
    SET pere=
        (SELECT numpers FROM personne 
        WHERE nom='Lannister' AND prenom='Jaime')
    WHERE pere=
        (SELECT numpers FROM personne 
        WHERE nom='Baratheon' AND prenom ='Robert');
    SELECT * FROM personne;

### Question 15 :
Affichez par ordre alphabétique le nom et le prénom des personnages qui sont des parents
avec leur nombre d'enfants

Les colonnes s'appeleront nom, prenom et progeniture

    SELECT mama.nom, mama.prenom, count(individu.numpers)  AS progeniture
    FROM personne AS individu JOIN personne AS mama ON mama.numpers= individu.mere
    GROUP BY individu.mere, mama.nom, mama.prenom
    UNION
    SELECT papa.nom, papa.prenom, count(individu.numpers) AS progeniture
    FROM personne AS individu JOIN personne AS papa ON papa.numpers= individu.pere
    GROUP BY individu.pere, papa.nom, papa.prenom
    ORDER BY 1, 2;

-----------------

### Question 16 :
Affichez par ordre alphabétique le nom et le prénom des personnes 
avec leur nombre d'enfants (colonne progeniture), 0 si elles n'en ont pas.


Attention Moodle travaille avec sqlite qui ne supporte pas la jointure droite

    SELECT p1.nom,
    p1.prenom,
    count(p2.pere OR p2.mere) AS progeniture
    FROM personne AS p1
    LEFT JOIN personne AS p2 ON p1.numpers=p2.pere OR p1.numpers=p2.mere
    GROUP BY p1.nom, p1.prenom
    HAVING progeniture >= 0
    ORDER BY p1.nom, p1.prenom, progeniture;

OU

    select mama.nom, mama.prenom, count(individu.numpers) as progeniture
    FROM personne as individu Join personne as mama on mama.numpers= individu.mere
    GROUP by individu.mere, mama.nom, mama.prenom
    union
    select papa.nom, papa.prenom, count(individu.numpers) as progeniture
    FROM personne as individu Join personne as papa on papa.numpers= individu.pere
    GROUP by individu.pere, papa.nom, papa.prenom
    union 
    select individu.nom, individu.prenom ,'0' as progeniture from personne as individu
    where not exists  (select* from personne p1 where  p1.pere = individu.numpers or p1.mere =individu.numpers)
    order by 1,2;

-----------------

### Question 17 :
Affichez tous les personnages ayant des descendants avec leur nombre de descendants. 
Les afficher par ordre décroissant de fécondité....départagez les ex aequo par ordre 
alphabètique

    with recursive descendants (ancetre, descendant)as (
    select pere, numpers from personne where pere is not null
        union
    select mere, numpers from personne where mere is not null
        union
    select d.ancetre, p.numpers 
        from descendants d join personne p 
        on p.pere=d.descendant or p.mere=d.descendant
        )
        
        select p1.nom, p1.prenom , count(descendant) from descendants d join  personne p1
        on p1.numpers =d.ancetre
        group by p1.nom, p1.prenom
        order by 3 desc,1,2;

-----------------

### Question 18 :
Affichez par ordre alphabétique le nom et le prénom de tous les descendants de Aegon Targaryen

    with recursive descendants (ancetre, descendant)as (
    select pere, numpers from personne where pere is not null
        union
    select mere, numpers from personne where mere is not null
        union
    select d.ancetre, p.numpers 
        from descendants d join personne p 
        on p.pere=d.descendant or p.mere=d.descendant
        )
        select p1.nom, p1.prenom from descendants d join  personne p1
        on p1.numpers =d.descendant
        where d.ancetre = 
        (select P2.numpers from personne p2 
        where p2.nom='Targaryen' and p2.prenom='Aegon')
    order by p1.nom, p1.prenom