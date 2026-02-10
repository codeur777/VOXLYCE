package com.example.voxlyce_back.dto;

import lombok.Data;

@Data
public class TwoFactorRequest {
    private String email;
    private String code;
}
