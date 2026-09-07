# Alerte JZ — V11 sécurisée

La V11 conserve l'interface et le fonctionnement temps réel validés en V10. Elle ajoute uniquement une authentification Supabase avant l'accès à l'application.

## Important avant de commencer

Ne supprimez pas votre V10 de sauvegarde. La V11 utilise le même projet Supabase et la même liste de chambres.

Le fichier `config.js` fourni dans ce dossier contient les valeurs génériques d'origine. **Avant de publier la V11, remplacez ce `config.js` par le `config.js` de votre V10 actuellement fonctionnelle** (celui qui contient votre Project URL et votre Publishable key). La Publishable key est faite pour être utilisée dans une application web ; ne mettez jamais une `secret key` ou une clé `service_role` dans la PWA.

## Étape 1 — Créer les comptes autorisés dans Supabase

Dans votre projet Supabase :

1. Ouvrez **Authentication** puis **Users**.
2. Utilisez **Add user**. Selon l'écran proposé par Supabase, vous pouvez créer directement un utilisateur ou lui envoyer une invitation.
3. Créez les comptes que vous souhaitez utiliser sur les appareils.

Pour rester simple sur le terrain, vous pouvez utiliser des comptes fonctionnels par poste, par exemple :

- un compte pour Cour Montmorency ;
- un compte pour Cour d'honneur ;
- un compte pour la Loge ;
- un compte pour la Direction.

Chaque appareil sera connecté une fois en amont. La session reste ensuite mémorisée sur cet appareil.

## Étape 2 — Sécuriser la base

1. Dans Supabase, ouvrez **SQL Editor**.
2. Cliquez sur **New query**.
3. Ouvrez le fichier `SECURISATION-V11.sql` fourni dans ce dossier.
4. Copiez tout son contenu et collez-le dans Supabase.
5. Cliquez sur **Run**.

Ce script retire les droits du rôle public `anon` et les attribue uniquement au rôle `authenticated`. Il remplace aussi les règles RLS de la V10 par des règles réservées aux utilisateurs connectés.

## Étape 3 — Remettre votre config.js V10

Copiez le `config.js` de votre V10 fonctionnelle dans le dossier V11 et acceptez le remplacement du fichier.

Vous ne devez modifier aucune autre clé ni aucun autre fichier.

## Étape 4 — Publier la V11 sur GitHub Pages

Remplacez les fichiers de votre dépôt `alerte-JZ` par ceux de la V11, comme vous l'avez fait pour la V10.

Attendez la mise à jour de GitHub Pages puis ouvrez l'application. Si l'ancienne version reste affichée, faites un rechargement forcé ou fermez complètement la PWA puis rouvrez-la.

## Étape 5 — Premier test

Au premier accès sur un appareil, une page **ACCÈS SÉCURISÉ** doit apparaître.

1. Saisissez l'adresse du compte Supabase autorisé.
2. Saisissez son mot de passe.
3. Cliquez sur **Se connecter**.
4. L'accueil V10 doit apparaître, avec `En direct` et `🔒 Connecté` en haut.

Fermez ensuite la PWA et rouvrez-la. Vous devez revenir directement sur l'application sans ressaisir le mot de passe.

## Étape 6 — Test de sécurité

Dans une fenêtre privée/navigation privée, ouvrez l'adresse de la PWA. Vous devez rester bloqué sur la page de connexion tant qu'aucun compte valide n'est saisi.

Puis faites le test multi-utilisateurs habituel : Montmorency, Cour d'honneur, Loge et Tableau de bord doivent continuer à se synchroniser en temps réel.

## Déconnexion

Le bouton **Déconnexion** en haut de l'application permet de retirer la session de l'appareil. Utilisez-le surtout si un téléphone change d'affectation ou ne doit plus accéder au suivi.

## Ce que la V11 ne change pas

- les 454 chambres du périmètre officiel ;
- l'organisation pair / impair ;
- le fonctionnement de la Loge ;
- le Tableau de bord en lecture seule ;
- les Archives ;
- la synchronisation Supabase Realtime ;
- le bouton Nouvel exercice.

La sécurité ajoutée est donc volontairement minimale côté interface : elle protège l'accès sans ralentir les agents une fois leur téléphone connecté.
