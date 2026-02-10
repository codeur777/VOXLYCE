package com.example.voxlyce_back.service;

import com.example.voxlyce_back.dto.*;
import com.example.voxlyce_back.model.*;
import org.springframework.stereotype.Service;

import java.util.stream.Collectors;

@Service
public class MappingService {

    public UserResponse toUserResponse(User user) {
        return UserResponse.builder()
                .id(user.getId())
                .email(user.getEmail())
                .firstName(user.getFirstName())
                .lastName(user.getLastName())
                .role(user.getRole())
                .isVerified(user.isVerified())
                .classroom(user.getClassroom() != null ? toClassroomResponse(user.getClassroom()) : null)
                .build();
    }

    public ClassroomResponse toClassroomResponse(Classroom classroom) {
        return ClassroomResponse.builder()
                .id(classroom.getId())
                .name(classroom.getName())
                .build();
    }

    public ElectionResponse toElectionResponse(Election election) {
        return ElectionResponse.builder()
                .id(election.getId())
                .title(election.getTitle())
                .type(election.getType())
                .status(election.getStatus())
                .startTime(election.getStartTime())
                .endTime(election.getEndTime())
                .classroom(election.getClassroom() != null ? toClassroomResponse(election.getClassroom()) : null)
                .positions(election.getPositions() != null ? 
                    election.getPositions().stream()
                        .map(this::toPositionResponse)
                        .collect(Collectors.toList()) : null)
                .build();
    }

    public PositionResponse toPositionResponse(Position position) {
        return PositionResponse.builder()
                .id(position.getId())
                .name(position.getName())
                .build();
    }

    public CandidateResponse toCandidateResponse(Candidate candidate) {
        return CandidateResponse.builder()
                .id(candidate.getId())
                .user(toUserResponse(candidate.getUser()))
                .position(toPositionResponse(candidate.getPosition()))
                .manifesto(candidate.getManifesto())
                .status(candidate.getStatus())
                .build();
    }
}
