# VOXLYCE - Architecture API Complète

## Vue d'ensemble du système

### Rôles
- **SUPER_ADMIN** : Accès total au système (toi)
- **ADMIN** : Gère la plateforme, valide candidatures et résultats
- **SUPERVISOR** : Vérifie les électeurs et lance les votes
- **STUDENT** : Peut voter et se porter candidat

### Types d'élections
- **CLASS_VOTE** : Vote de classe (Délégué, Vice-délégué, Secrétaire, Vice-secrétaire)
- **COMMITTEE_VOTE** : Vote du comité (Délégué général, Président CACA, Trésorier, etc.)

---

## ENDPOINTS API

### 1. AUTHENTICATION (`/api/v1/auth`)

| Méthode | Endpoint | Description | Accès |
|---------|----------|-------------|-------|
| POST | `/register` | Inscription d'un nouvel utilisateur | Public |
| POST | `/login` | Connexion (retourne mfaRequired si 2FA activé) | Public |
| POST | `/verify-2fa` | Vérification du code 2FA | Public |
| POST | `/forgot-password` | Demande de réinitialisation de mot de passe | Public |
| POST | `/reset-password` | Réinitialisation du mot de passe | Public |
| GET | `/me` | Informations de l'utilisateur connecté | Authenticated |

---

### 2. SUPER ADMIN (`/api/v1/super-admin`)

| Méthode | Endpoint | Description | Accès |
|---------|----------|-------------|-------|
| GET | `/users` | Liste tous les utilisateurs | SUPER_ADMIN |
| POST | `/users` | Créer un utilisateur (admin, supervisor) | SUPER_ADMIN |
| PUT | `/users/{id}` | Modifier un utilisateur | SUPER_ADMIN |
| DELETE | `/users/{id}` | Supprimer un utilisateur | SUPER_ADMIN |
| PUT | `/users/{id}/role` | Changer le rôle d'un utilisateur | SUPER_ADMIN |
| GET | `/audit-logs` | Consulter tous les logs d'audit | SUPER_ADMIN |
| GET | `/audit-logs/export` | Exporter les logs (CSV) | SUPER_ADMIN |
| GET | `/statistics` | Statistiques globales du système | SUPER_ADMIN |
| POST | `/classrooms` | Créer une classe | SUPER_ADMIN |
| PUT | `/classrooms/{id}` | Modifier une classe | SUPER_ADMIN |
| DELETE | `/classrooms/{id}` | Supprimer une classe | SUPER_ADMIN |

---

### 3. ADMIN (`/api/v1/admin`)

| Méthode | Endpoint | Description | Accès |
|---------|----------|-------------|-------|
| **Gestion des élections** |
| GET | `/elections` | Liste toutes les élections | ADMIN, SUPER_ADMIN |
| POST | `/elections` | Créer une nouvelle élection | ADMIN, SUPER_ADMIN |
| PUT | `/elections/{id}` | Modifier une élection | ADMIN, SUPER_ADMIN |
| DELETE | `/elections/{id}` | Supprimer une élection | ADMIN, SUPER_ADMIN |
| POST | `/elections/{id}/positions` | Ajouter un poste à une élection | ADMIN, SUPER_ADMIN |
| DELETE | `/positions/{id}` | Supprimer un poste | ADMIN, SUPER_ADMIN |
| **Gestion des candidatures** |
| GET | `/candidates/pending` | Liste des candidatures en attente | ADMIN, SUPER_ADMIN |
| GET | `/candidates` | Liste toutes les candidatures | ADMIN, SUPER_ADMIN |
| PUT | `/candidates/{id}/validate` | Valider une candidature | ADMIN, SUPER_ADMIN |
| PUT | `/candidates/{id}/reject` | Rejeter une candidature | ADMIN, SUPER_ADMIN |
| **Gestion des utilisateurs** |
| GET | `/students` | Liste tous les étudiants | ADMIN, SUPER_ADMIN |
| GET | `/students/unverified` | Liste des étudiants non vérifiés | ADMIN, SUPER_ADMIN |
| PUT | `/students/{id}/verify` | Vérifier un étudiant | ADMIN, SUPER_ADMIN |
| DELETE | `/students/{id}` | Supprimer un étudiant | ADMIN, SUPER_ADMIN |
| **Gestion des résultats** |
| GET | `/elections/{id}/results` | Voir les résultats d'une élection | ADMIN, SUPER_ADMIN |
| POST | `/elections/{id}/validate-results` | Valider les résultats (immuables) | ADMIN, SUPER_ADMIN |
| POST | `/elections/{id}/relaunch` | Relancer une élection (en cas d'égalité) | ADMIN, SUPER_ADMIN |
| **Superviseurs** |
| GET | `/supervisors` | Liste des superviseurs | ADMIN, SUPER_ADMIN |
| POST | `/supervisors` | Créer un superviseur | ADMIN, SUPER_ADMIN |
| PUT | `/supervisors/{id}/assign-classroom` | Assigner une classe à un superviseur | ADMIN, SUPER_ADMIN |

---

### 4. SUPERVISOR (`/api/v1/supervisor`)

| Méthode | Endpoint | Description | Accès |
|---------|----------|-------------|-------|
| GET | `/elections` | Liste des élections de sa classe | SUPERVISOR |
| GET | `/elections/{id}` | Détails d'une élection | SUPERVISOR |
| GET | `/elections/{id}/electors` | Liste des électeurs inscrits | SUPERVISOR |
| GET | `/elections/{id}/elector-count` | Nombre d'électeurs | SUPERVISOR |
| DELETE | `/elections/{id}/electors/{userId}` | Supprimer un électeur | SUPERVISOR |
| POST | `/elections/{id}/start` | Lancer le vote (démarre le compte à rebours 24h) | SUPERVISOR |
| GET | `/elections/{id}/status` | Statut du vote en cours | SUPERVISOR |

---

### 5. STUDENT/VOTER (`/api/v1/student`)

| Méthode | Endpoint | Description | Accès |
|---------|----------|-------------|-------|
| **Candidature** |
| POST | `/candidates` | S'inscrire comme candidat pour un poste | STUDENT |
| GET | `/candidates/my-candidatures` | Mes candidatures | STUDENT |
| PUT | `/candidates/{id}` | Modifier ma candidature | STUDENT |
| DELETE | `/candidates/{id}` | Retirer ma candidature | STUDENT |
| **Vote** |
| GET | `/elections` | Liste des élections disponibles pour voter | STUDENT |
| GET | `/elections/{id}` | Détails d'une élection | STUDENT |
| GET | `/elections/{id}/candidates` | Liste des candidats pour une élection | STUDENT |
| POST | `/vote` | Voter pour un candidat | STUDENT |
| GET | `/elections/{id}/voting-status` | Vérifier si j'ai déjà voté | STUDENT |
| **Résultats** |
| GET | `/elections/{id}/results` | Voir les résultats validés | STUDENT |
| GET | `/elections/history` | Historique de toutes les élections | STUDENT |

---

### 6. PUBLIC (`/api/v1/elections`)

| Méthode | Endpoint | Description | Accès |
|---------|----------|-------------|-------|
| GET | `/` | Liste des élections publiques | Public |
| GET | `/{id}` | Détails d'une élection publique | Public |
| GET | `/{id}/results` | Résultats validés d'une élection | Public |

---

## MODÈLES DE DONNÉES

### User
```json
{
  "id": 1,
  "email": "student@example.com",
  "firstName": "John",
  "lastName": "Doe",
  "role": "STUDENT",
  "isVerified": true,
  "twoFactorEnabled": true,
  "classroom": {
    "id": 1,
    "name": "Licence 3 Informatique"
  }
}
```

### Election
```json
{
  "id": 1,
  "title": "Élection Délégués L3 Info",
  "type": "CLASS_VOTE",
  "status": "ONGOING",
  "startTime": "2026-02-15T08:00:00",
  "endTime": "2026-02-16T08:00:00",
  "classroom": {
    "id": 1,
    "name": "Licence 3 Informatique"
  },
  "positions": [
    {
      "id": 1,
      "name": "Délégué"
    },
    {
      "id": 2,
      "name": "Vice-délégué"
    }
  ]
}
```

### Candidate
```json
{
  "id": 1,
  "user": {
    "id": 5,
    "firstName": "Alice",
    "lastName": "Martin"
  },
  "position": {
    "id": 1,
    "name": "Délégué"
  },
  "manifesto": "Je m'engage à représenter tous les étudiants...",
  "status": "ACCEPTED"
}
```

### VoteRequest
```json
{
  "electionId": 1,
  "positionId": 1,
  "candidateId": 3
}
```

### ElectionResult
```json
{
  "electionId": 1,
  "status": "VALIDATED",
  "hasTie": false,
  "resultsByPosition": {
    "Délégué": {
      "Alice Martin": 45,
      "Bob Dupont": 32,
      "Charlie Durand": 18
    },
    "Vice-délégué": {
      "Emma Petit": 50,
      "Frank Moreau": 45
    }
  }
}
```

---

## STATUTS

### ElectionStatus
- `PENDING` : Élection créée, pas encore lancée
- `ONGOING` : Vote en cours (24h)
- `COMPLETED` : Vote terminé, résultats non validés
- `TIE` : Égalité détectée
- `VALIDATED` : Résultats validés (immuables)
- `CANCELLED` : Élection annulée

### CandidateStatus
- `PENDING` : Candidature en attente de validation
- `ACCEPTED` : Candidature acceptée
- `REJECTED` : Candidature rejetée
- `WITHDRAWN` : Candidature retirée par le candidat

---

## RÈGLES MÉTIER

1. **Anonymat** : Les votes utilisent un hash (SHA-256) de `email + electionId` pour garantir l'anonymat
2. **Vote unique** : Un électeur ne peut voter qu'une seule fois par poste et par élection
3. **Fenêtre de vote** : 24h après le lancement par le superviseur
4. **Validation** : Les résultats doivent être validés par l'admin avant d'être publics
5. **Immuabilité** : Une fois validés, les résultats ne peuvent plus être modifiés
6. **Égalité** : En cas d'égalité, l'admin est notifié et peut relancer le vote
7. **Audit** : Toutes les actions sensibles sont enregistrées dans les logs

---

## NOTIFICATIONS (À IMPLÉMENTER)

- Email envoyé lors de l'inscription
- Email avec code 2FA
- Email de validation de candidature
- Email de lancement du vote
- Email de résultats validés
- Email en cas d'égalité

---

## SÉCURITÉ

- JWT avec expiration 10h
- 2FA obligatoire pour tous les utilisateurs
- CORS configuré pour origines spécifiques
- Rate limiting sur les endpoints sensibles
- Logs d'audit pour traçabilité
- Hachage BCrypt pour les mots de passe
