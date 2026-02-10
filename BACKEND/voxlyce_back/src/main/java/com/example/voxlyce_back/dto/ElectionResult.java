package com.example.voxlyce_back.dto;

import lombok.Builder;
import lombok.Data;
import java.util.Map;

@Data
@Builder
public class ElectionResult {
    private Long electionId;
    private Map<String, Map<String, Long>> resultsByPosition; // Position Name -> {Candidate Name -> Vote Count}
    private boolean hasTie;
}
