package com.example.voxlyce_back.dto;

import lombok.Data;

@Data
public class PaymentRequest {
    private Long candidateId;
    private String paymentMethod; // MOBILE_MONEY, BANK_TRANSFER, etc.
    private String paymentReference; // Référence de transaction
    private Double amount; // Montant payé
}
