# Alerte JZ — V11.2 correctifs

Cette version part de la V11.1 « compte unique » et conserve son fonctionnement multi-utilisateurs sécurisé via Supabase.

Modifications principales :
- nouvelle liste officielle de 451 chambres suivies ;
- Cour d’honneur : 225 chambres impaires ;
- Cour Montmorency : 226 chambres paires ;
- Loge et Tableau de bord utilisent exactement le même périmètre de 451 chambres ;
- correction F54 → F.54 ;
- bouton « À propos » avec explication du fonctionnement ;
- ajout du logo de l’Internat Jean Zay ;
- écran d’accès sécurisé et bandeau aux couleurs du logo ;
- mention discrète « Conception : Sophie Cheyrou ».

## Important pour la mise en ligne
Le `config.js` fourni reste un modèle sans vos informations Supabase. Conservez ou recopiez le `config.js` de votre V11.1 actuellement fonctionnelle avant la publication sur GitHub Pages.

Aucune nouvelle modification SQL n’est nécessaire pour ces changements de liste : l’application prend `rooms-data.js` comme périmètre officiel et les anciens états de chambres retirées sont simplement ignorés.
