# 🐳 Voxlyce - Système de Vote Sécurisé

Voxlyce est une plateforme de vote numérique moderne conçue pour gérer les élections de délégués de classe et les comités généraux. Elle offre un environnement sécurisé, anonyme et transparent grâce à une architecture robuste basée sur Spring Boot et Flutter.

### Fonctionnalités Clés :
- **Authentification double facteur (2FA)** pour une sécurité maximale.
- **Gestion multi-rôles** : Super Admin, Admin plateforme, Superviseurs et Étudiants.
- **Anonymat garanti** : Utilisation de hachage cryptographique pour assurer l'unicité des votes sans compromettre l'identité.
- **Transparence et Traçabilité** : Journal d'audit complet pour toutes les actions sensibles.
- **Élections flexibles** : Gestion des dates, des postes personnalisés et détection automatique d'égalité.

Ce projet utilise Docker, Docker Compose, Spring Boot, Flutter Web et PostgreSQL.

## Lancer le projet

```bash
docker-compose up --build
```

- Frontend : http://localhost
- Backend : http://localhost:8080
- PostgreSQL : localhost:5432 (DB: voxlyce_db)

**Ne jamais publier le fichier `.env` !**
