# Alerte JZ — V11.1 « compte unique »

Cette version conserve la V10/V11 telle qu'elle fonctionne aujourd'hui et simplifie seulement la connexion : **un seul compte pour tous les téléphones, tablettes et ordinateurs autorisés**.

## Principe

Les agents voient un identifiant commun : **SECURITE-JZ**. Ils n'ont qu'à saisir le mot de passe lors de la première connexion sur leur appareil. La session est ensuite mémorisée par Supabase sur cet appareil.

Supabase exige techniquement une adresse au format e-mail pour un compte avec mot de passe. La V11.1 masque complètement cette adresse : elle est stockée dans `config.js` et n'est jamais demandée aux agents.

## Étape 1 — Créer UN SEUL utilisateur Supabase

Dans votre projet Supabase :

1. Ouvrez **Authentication** > **Users**.
2. Cliquez sur **Add user** / **Create new user**.
3. Créez un seul utilisateur avec :
   - une adresse technique de votre choix au format e-mail ;
   - un mot de passe solide qui sera le mot de passe commun aux agents.
4. Conservez cette adresse et ce mot de passe.

Vous n'avez pas besoin de créer 10 adresses différentes : **une seule suffit**.

## Étape 2 — Sécuriser la base

Si vous n'avez pas encore exécuté `SECURISATION-V11.sql`, faites-le maintenant dans **SQL Editor** > **New query** > collez le script > **Run**.

Si vous l'avez déjà exécuté pour la V11, inutile de le refaire.

## Étape 3 — Configurer `config.js`

Ouvrez le `config.js` de la V11.1.

Recopiez depuis votre `config.js` V10 fonctionnel :

- `supabaseUrl`
- `supabasePublishableKey`

Puis remplacez :

`COLLEZ_ICI_L_ADRESSE_TECHNIQUE_DU_COMPTE_UNIQUE`

par l'adresse du seul utilisateur que vous venez de créer dans Supabase.

Vous pouvez conserver :

`sharedLoginId: "SECURITE-JZ"`

ou choisir un autre identifiant commun, par exemple `ALERTE-JZ`.

### Exemple fictif

```js
window.APP_CONFIG = {
  supabaseUrl: "https://xxxxxxxx.supabase.co",
  supabasePublishableKey: "sb_publishable_xxxxxxxxx",
  sharedLoginId: "SECURITE-JZ",
  sharedAuthEmail: "securite.jz@exemple.fr"
};
```

L'adresse `securite.jz@exemple.fr` n'apparaît jamais sur l'écran des agents.

## Étape 4 — Publier sur GitHub Pages

Remplacez les fichiers de votre dépôt `alerte-JZ` par les fichiers de la V11.1, comme pour les versions précédentes.

Attendez la mise à jour de GitHub Pages, puis rechargez complètement la PWA si nécessaire.

## Étape 5 — Premier test

Sur un téléphone :

1. ouvrez l'application ;
2. l'identifiant **SECURITE-JZ** est déjà affiché ;
3. saisissez uniquement le mot de passe commun ;
4. cliquez sur **Se connecter**.

Fermez ensuite complètement la PWA et rouvrez-la : vous devez revenir directement à l'accueil sans saisir à nouveau le mot de passe.

Faites ensuite les tests habituels Montmorency, Cour d'honneur, Loge et Tableau de bord.

## Important

Avec un compte unique, tous les appareils ont les mêmes droits. C'est volontaire pour gagner du temps pendant un exercice. En contrepartie, l'historique ne permet pas d'identifier nominativement l'agent qui a cliqué. Le rôle choisi dans la PWA (Montmorency, Cour d'honneur, Loge) reste cependant connu au moment de l'action.

Si le mot de passe commun est compromis, changez-le dans Supabase et déconnectez les appareils concernés.
