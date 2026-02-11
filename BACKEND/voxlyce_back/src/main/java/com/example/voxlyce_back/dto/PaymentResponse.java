package com.example.voxlyce_back.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PaymentResponse {
    private Long candidateId;
    private Boolean paid;
    private Double amount;
    private String paymentReference;
    private LocalDateTime paymentDate;
    private String message;
}
