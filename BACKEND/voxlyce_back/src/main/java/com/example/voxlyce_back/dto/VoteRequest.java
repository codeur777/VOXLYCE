package com.example.voxlyce_back.dto;

import lombok.Data;

@Data
public class VoteRequest {
    private Long electionId;
    private Long positionId;
    private Long candidateId;
}
