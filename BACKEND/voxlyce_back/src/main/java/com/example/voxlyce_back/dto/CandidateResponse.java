package com.example.voxlyce_back.dto;

import com.example.voxlyce_back.model.CandidateStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CandidateResponse {
    private Long id;
    private UserResponse user;
    private PositionResponse position;
    private String manifesto;
    private CandidateStatus status;
    private String studentCardPhotoUrl;
    private Boolean depositFeePaid;
    private Double depositFeeAmount;
    private String paymentReference;
}
