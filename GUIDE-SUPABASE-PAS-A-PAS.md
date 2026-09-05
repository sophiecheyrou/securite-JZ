# ALERTE JZ V10 — Guide Supabase pas à pas

Cette V10 conserve l'interface de la V9 et ajoute la synchronisation en temps réel entre plusieurs téléphones, tablettes ou ordinateurs.

## Ce qu'il faut préparer

- Le dossier de la V10 décompressé.
- Un compte Supabase.
- L'accès au dépôt GitHub `alerte-JZ` pour remplacer les fichiers de la V9 quand les tests seront terminés.

## ÉTAPE 1 — Créer le projet Supabase

1. Aller sur **supabase.com** et se connecter.
2. Cliquer sur **New project**.
3. Choisir votre organisation.
4. Nom du projet : par exemple **alerte-jz**.
5. Choisir un mot de passe de base de données solide et le conserver dans un endroit sûr. Il ne sera PAS à mettre dans la PWA.
6. Choisir une région européenne proche si Supabase vous demande une région.
7. Cliquer sur **Create new project** et attendre que le projet soit prêt.

## ÉTAPE 2 — Créer la base de données Alerte JZ

1. Dans le menu de gauche de Supabase, ouvrir **SQL Editor**.
2. Cliquer sur **New query**.
3. Sur votre ordinateur, ouvrir le fichier **supabase.sql** contenu dans le dossier V10 avec un éditeur de texte.
4. Faire **Cmd+A** sur Mac (ou Ctrl+A sur Windows), puis **Cmd+C** / Ctrl+C.
5. Coller tout le contenu dans la fenêtre SQL Editor.
6. Cliquer sur **Run**.
7. Attendre le message de réussite.

Le script crée automatiquement :
- la liste des chambres ;
- la session d'exercice ;
- le statut partagé de chaque chambre ;
- l'historique de chaque clic ;
- les règles de sécurité de la base ;
- la diffusion en temps réel (Realtime).

Vous n'avez PAS besoin d'importer manuellement `rooms_import.csv`.

## ÉTAPE 3 — Récupérer les 2 valeurs de connexion

Dans Supabase, ouvrir le bouton **Connect** de votre projet. Supabase y affiche notamment :

1. **Project URL**, qui ressemble à :
   `https://xxxxxxxxxxxx.supabase.co`
2. **Publishable key**, qui commence normalement par :
   `sb_publishable_...`

Si vous ne les voyez pas dans Connect, la clé est également disponible dans **Settings > API Keys**.

IMPORTANT : ne copiez JAMAIS une **Secret key** (`sb_secret_...`) ni une ancienne clé `service_role` dans la PWA.

## ÉTAPE 4 — Renseigner config.js

1. Dans le dossier V10, ouvrir le fichier **config.js** avec TextEdit, VS Code ou un éditeur de texte.
2. Vous verrez :

```js
window.APP_CONFIG = {
  supabaseUrl: "COLLEZ_ICI_L_URL_DU_PROJET",
  supabasePublishableKey: "COLLEZ_ICI_LA_CLE_PUBLISHABLE"
};
```

3. Remplacer uniquement le texte entre guillemets.

Exemple fictif :

```js
window.APP_CONFIG = {
  supabaseUrl: "https://abcdefghijkl.supabase.co",
  supabasePublishableKey: "sb_publishable_EXEMPLE_EXEMPLE_EXEMPLE"
};
```

4. Enregistrer le fichier.

## ÉTAPE 5 — Tester AVANT de remplacer la V9 publique

Le fonctionnement Supabase exige que la PWA soit servie par un site web. Le plus simple pour vous est de créer d'abord une branche de test sur GitHub, ou de déposer la V10 dans un dépôt GitHub Pages de test.

Une fois la V10 en ligne :

1. Ouvrir la PWA sur **deux appareils différents** (par exemple votre ordinateur et votre téléphone).
2. Sur le premier appareil, ouvrir **COUR MONTMORENCY**.
3. Sur le second, ouvrir **TABLEAU DE BORD**.
4. Sur le premier, cliquer sur une chambre paire rouge.
5. Elle doit devenir verte sur le premier appareil et disparaître presque immédiatement de la liste des non-localisées sur le second.
6. Tester ensuite une chambre impaire depuis **COUR D'HONNEUR**.
7. Tester enfin une chambre depuis **LOGE** : elle doit devenir jaune et le compteur « Sortis » doit changer sur tous les appareils.

En haut de la PWA, l'indicateur **En direct** signifie que la connexion Realtime est établie. Sur petit téléphone, seul le point vert peut être visible.

## ÉTAPE 6 — Tester un nouvel exercice

1. Laisser deux appareils ouverts.
2. Sur l'un d'eux, cliquer sur **Nouvel exercice** puis confirmer.
3. Toutes les chambres doivent repasser à **Non localisé** sur les deux appareils.
4. Les compteurs doivent redevenir identiques partout.

## ÉTAPE 7 — Déployer sur votre GitHub Pages actuel

Quand les tests sont concluants :

1. Conserver une copie de sauvegarde de la V9.
2. Dans le dépôt GitHub de `alerte-JZ`, remplacer les fichiers de la V9 par **tous les fichiers** du dossier V10.
3. Vérifier particulièrement que le `config.js` mis en ligne contient bien VOTRE Project URL et VOTRE Publishable key.
4. Attendre une à deux minutes que GitHub Pages se mette à jour.
5. Fermer puis rouvrir la PWA sur les appareils. Si une ancienne version reste affichée, supprimer/réinstaller l'icône PWA ou vider les données du site une fois.

## Ce que fait la V10 lorsqu'il y a plusieurs adultes

- Chaque clic est enregistré dans la même base centrale.
- La chambre change sur tous les appareils connectés.
- Le Tableau de bord reste strictement en lecture seule.
- Un clic dans les cours donne le statut **Présent**.
- Un clic à la loge donne le statut **Sorti**.
- Un second clic sur la même chambre dans le même écran la remet **Non localisée**.
- Chaque action est conservée dans un historique avec l'heure, le poste et un identifiant technique de l'appareil.
- Si deux actions arrivent presque en même temps, la base applique l'état le plus récent et conserve les deux actions dans l'historique.

## Sécurité à connaître

La **Publishable key** est conçue pour être utilisée dans un navigateur et peut donc être visible dans le code du site. La V10 active des règles de sécurité Supabase (RLS) et limite les écritures opérationnelles à des fonctions prévues à cet effet.

Cependant, la PWA étant publiée sur un site GitHub Pages public et ne demandant pas encore d'identification personnelle, une personne qui connaît l'adresse du site pourrait théoriquement ouvrir l'application. Pour un déploiement opérationnel définitif, il sera préférable d'ajouter ensuite un contrôle d'accès simple pour les personnels autorisés.

## En cas de problème

- **« Mode local »** : `config.js` n'est pas encore renseigné correctement.
- **« Synchronisation interrompue »** : vérifier la connexion Internet et que `supabase.sql` a bien été exécuté sans erreur.
- Un appareil ne se met pas à jour : actualiser une fois la page et vérifier que l'indicateur est vert.
- Une erreur Supabase apparaît : conserver une capture d'écran du message exact avant de modifier quoi que ce soit.
