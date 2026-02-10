package com.example.voxlyce_back.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Map;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VotingStatusResponse {
    private Long electionId;
    private Map<Long, Boolean> votedByPosition; // positionId -> hasVoted
}
