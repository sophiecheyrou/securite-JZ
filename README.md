# Alerte JZ — V10 multi-utilisateurs

Cette version reprend l'interface stable de la V9 et ajoute une synchronisation Supabase en temps réel.

## Fichiers à utiliser
- `index.html` : application.
- `styles.css` : présentation.
- `app.js` : logique V10.
- `rooms-data.js` / `rooms.json` : liste locale de référence.
- `config.js` : les 2 valeurs Supabase à renseigner.
- `supabase.sql` : script complet à exécuter une fois dans Supabase.
- `GUIDE-SUPABASE-PAS-A-PAS.md` : procédure détaillée pour un débutant.

## V10 : comportement partagé
- Cour Montmorency : chambres paires, clic = Présent.
- Cour d'honneur : chambres impaires, clic = Présent.
- Loge : clic = Sorti.
- Tableau de bord : lecture seule.
- Tous les appareils reçoivent les changements en temps réel.
- « Nouvel exercice » crée une nouvelle session commune à tous les appareils.
- L'historique des clics est conservé dans Supabase.

Ne jamais mettre de clé Supabase `secret` ou `service_role` dans `config.js`. Utiliser uniquement la **Publishable key**.
