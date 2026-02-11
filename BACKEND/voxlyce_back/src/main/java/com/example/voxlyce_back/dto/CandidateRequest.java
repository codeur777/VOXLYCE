package com.example.voxlyce_back.dto;

import lombok.Data;

@Data
public class CandidateRequest {
    private Long positionId;
    private String manifesto;
    private String studentCardPhotoUrl; // URL de la photo (optionnel)
}
