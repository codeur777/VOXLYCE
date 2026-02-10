package com.example.voxlyce_back.dto;

import com.example.voxlyce_back.model.ElectionType;
import lombok.Data;
import java.util.List;

@Data
public class ElectionRequest {
    private String title;
    private ElectionType type;
    private Long classroomId; // For CLASS_VOTE
    private List<String> positionNames;
}
