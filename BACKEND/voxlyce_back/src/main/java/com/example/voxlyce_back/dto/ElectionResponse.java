package com.example.voxlyce_back.dto;

import com.example.voxlyce_back.model.ElectionStatus;
import com.example.voxlyce_back.model.ElectionType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ElectionResponse {
    private Long id;
    private String title;
    private ElectionType type;
    private ElectionStatus status;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private ClassroomResponse classroom;
    private List<PositionResponse> positions;
}
