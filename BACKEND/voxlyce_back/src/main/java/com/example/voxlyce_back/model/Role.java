package com.example.voxlyce_back.model;

public enum Role {
    SUPER_ADMIN,  // Toi - accès total au système
    ADMIN,        // Gère la plateforme, valide candidatures et résultats
    SUPERVISOR,   // Vérifie les électeurs et lance les votes
    STUDENT       // Étudiant - peut voter et se porter candidat
}
