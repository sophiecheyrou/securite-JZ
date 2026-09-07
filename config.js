// ALERTE JZ — V11.1 COMPTE UNIQUE
// Ne mettez JAMAIS ici une "secret key" ou une clé "service_role".
// 1) Recopiez les 2 valeurs Supabase de votre config.js V10 fonctionnel.
// 2) Créez UN SEUL utilisateur dans Supabase Auth et indiquez son adresse technique dans sharedAuthEmail.
// Les agents ne verront jamais cette adresse : ils utilisent seulement l'identifiant commun ci-dessous.
window.APP_CONFIG = {
  supabaseUrl: "https://asqdmrrxhxcuwcttnlpg.supabase.co",
  supabasePublishableKey: "sb_publishable_COsE0RIvP2xi0vx2vklgIA_b2S_N8Kc",

  // Identifiant affiché à tous les agents. Vous pouvez le changer si vous le souhaitez.
  sharedLoginId: "SECURITE-JZ",

  // Adresse du SEUL compte créé dans Supabase Authentication > Users.
  // Cette adresse est uniquement technique et n'est jamais demandée aux agents.
  sharedAuthEmail: "cheyrousophie@gmail.com"
};
