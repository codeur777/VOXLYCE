package com.example.voxlyce_back.dto;

import lombok.Data;

@Data
public class PhotoUploadRequest {
    private Long candidateId;
    private String photoUrl; // URL de la photo uploadée
}
