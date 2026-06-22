# site

Site personnel de Ganti Busime.

## Lancement local

1. Installer les dépendances avec `npm install`.
2. Copier `.env.example` en `.env` et renseigner les variables Gmail.
3. Démarrer le serveur avec `npm start`.

## Configuration Gmail

1. Activer la validation en deux étapes sur le compte Google.
2. Créer un mot de passe d'application Gmail.
3. Renseigner `GMAIL_USER` et `GMAIL_APP_PASSWORD` dans `.env`.

Le formulaire de contact enverra alors les messages vers `gantibusiness@gmail.com` via Gmail.
