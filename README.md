# Voxlyce - Système de Vote Électronique pour Lycées 🗳️

[![Status](https://img.shields.io/badge/status-deployed-success)](http://localhost)
[![Frontend](https://img.shields.io/badge/frontend-Flutter-blue)](http://localhost)
[![Backend](https://img.shields.io/badge/backend-Spring%20Boot-green)](http://localhost:8080)
[![Database](https://img.shields.io/badge/database-PostgreSQL-blue)](http://localhost:5433)

Voxlyce est une plateforme moderne de vote électronique conçue spécifiquement pour les établissements scolaires. Elle permet aux étudiants de voter de manière sécurisée, transparente et efficace pour les élections de comité et de classe.

## 🚀 Démarrage Rapide

### Prérequis
- Docker Desktop installé et en cours d'exécution
- Git

### Installation en 3 Étapes

1. **Cloner le projet**
```bash
git clone <repository-url>
cd VOXLYCE
```

2. **Démarrer les services**
```bash
docker-compose up -d
```

3. **Accéder à l'application**
```
Frontend: http://localhost
Backend API: http://localhost:8080/api/v1
```

### Comptes de Test

| Rôle | Email | Mot de passe |
|------|-------|--------------|
| Étudiant | student@voxlyce.com | Student123! |
| Superviseur | supervisor@voxlyce.com | Super123! |
| Administrateur | admin@voxlyce.com | Admin123! |

## 📱 Fonctionnalités

### ✅ Implémentées
- 🔐 Authentification JWT sécurisée
- 📋 Liste des élections avec statuts
- 🗳️ Vote pour les candidats par position
- ✅ Confirmation des votes
- 💾 Stockage sécurisé des tokens
- 🎨 Interface utilisateur premium
- ⚠️ Gestion des erreurs
- ⏳ États de chargement

### 🚧 En Développement
- 📝 Inscription de nouveaux utilisateurs
- 🔒 Vérification 2FA
- 👨‍💼 Tableau de bord administrateur
- 👮 Écrans superviseur
- 🎓 Inscription comme candidat
- 💰 Paiement des frais de candidature
- 📊 Visualisation des résultats
- 👤 Gestion du profil utilisateur

## 🏗️ Architecture

```
┌─────────────────────────────────────────┐
│    Frontend (Flutter Web + Nginx)      │
│    Port: 80                             │
│    - BLoC State Management              │
│    - Premium UI Components              │
│    - JWT Authentication                 │
└──────────────┬──────────────────────────┘
               │ HTTP/REST API
               ▼
┌─────────────────────────────────────────┐
│    Backend (Spring Boot)                │
│    Port: 8080                           │
│    - JWT Security                       │
│    - Role-based Access Control          │
│    - RESTful API                        │
└──────────────┬──────────────────────────┘
               │ JDBC
               ▼
┌─────────────────────────────────────────┐
│    Database (PostgreSQL)                │
│    Port: 5433                           │
│    - Users, Elections, Votes            │
│    - Audit Logs                         │
└─────────────────────────────────────────┘
```

## 🛠️ Technologies

### Frontend
- **Flutter 3.5.0+** - Framework UI multiplateforme
- **BLoC** - Gestion d'état
- **Dio** - Client HTTP
- **Flutter Secure Storage** - Stockage sécurisé
- **ScreenUtil** - UI responsive

### Backend
- **Spring Boot 3.4.2** - Framework Java
- **Spring Security** - Authentification JWT
- **PostgreSQL** - Base de données
- **Maven** - Gestion des dépendances

### DevOps
- **Docker** - Conteneurisation
- **Docker Compose** - Orchestration
- **Nginx** - Serveur web

## 📚 Documentation

- [Guide de Démarrage](GETTING_STARTED.md) - Guide complet pour commencer
- [Configuration Frontend](FRONTEND_SETUP_COMPLETE.md) - Documentation frontend détaillée
- [Résumé d'Intégration](FRONTEND_INTEGRATION_SUMMARY.md) - Vue d'ensemble de l'intégration
- [Architecture API](BACKEND/API_ARCHITECTURE.md) - Documentation de l'API backend
- [Endpoints de Paiement](BACKEND/PAYMENT_AND_PHOTO_ENDPOINTS.md) - API de paiement
- [Corrections Appliquées](CORRECTIONS_APPLIQUEES.md) - Historique des corrections
- [Succès du Déploiement](DEPLOYMENT_SUCCESS.md) - Statut du déploiement

## 🧪 Tests

### Avec Postman
1. Importer la collection: `voxlyce_postman_collection.json`
2. Exécuter le dossier "Setup" pour créer les utilisateurs de test
3. Exécuter "Authentication" → "Login Student" pour obtenir le token JWT
4. Le token est automatiquement sauvegardé pour les requêtes suivantes

### Tests Manuels
```bash
# Tester l'API backend
curl http://localhost:8080/api/v1/elections

# Tester le frontend
# Ouvrir http://localhost dans le navigateur
```

## 🔧 Commandes Utiles

### Gestion Docker
```bash
# Démarrer les services
docker-compose up -d

# Arrêter les services
docker-compose down

# Voir les logs
docker-compose logs -f

# Reconstruire les images
docker-compose build --no-cache

# Réinitialiser la base de données
docker-compose down -v
docker-compose up -d
```

### Développement Frontend
```bash
cd FRONTEND/voxlyce_front

# Installer les dépendances
flutter pub get

# Lancer en mode développement
flutter run

# Build pour le web
flutter build web --release

# Analyser le code
flutter analyze
```

### Développement Backend
```bash
cd BACKEND/voxlyce_back

# Compiler
mvn clean install

# Lancer
mvn spring-boot:run

# Tests
mvn test
```

## 🎯 Roadmap

### Phase 1 - MVP ✅
- [x] Authentification utilisateur
- [x] Liste des élections
- [x] Système de vote
- [x] Interface utilisateur de base

### Phase 2 - Fonctionnalités Avancées 🚧
- [ ] Tableau de bord administrateur
- [ ] Gestion des candidatures
- [ ] Système de paiement
- [ ] Visualisation des résultats

### Phase 3 - Optimisations 📋
- [ ] Notifications push
- [ ] Mises à jour en temps réel
- [ ] Support hors ligne
- [ ] Authentification biométrique

### Phase 4 - Production 📋
- [ ] Tests automatisés
- [ ] CI/CD pipeline
- [ ] Monitoring et alertes
- [ ] Documentation utilisateur

## 🤝 Contribution

Les contributions sont les bienvenues! Pour contribuer:

1. Fork le projet
2. Créer une branche (`git checkout -b feature/AmazingFeature`)
3. Commit les changements (`git commit -m 'Add AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 👥 Équipe

- **Développement Frontend** - Flutter/Dart
- **Développement Backend** - Spring Boot/Java
- **DevOps** - Docker/CI-CD
- **Design UI/UX** - Premium Design System

## 📞 Support

Pour toute question ou problème:
- 📧 Email: support@voxlyce.com
- 📚 Documentation: Voir les fichiers MD dans le projet
- 🐛 Issues: Utiliser le système d'issues GitHub

## 🎉 Remerciements

- Eden Premium UI Template pour les composants UI
- Spring Boot pour le framework backend robuste
- Flutter pour le framework frontend multiplateforme
- La communauté open source

---

**Fait avec ❤️ pour améliorer la démocratie scolaire**
