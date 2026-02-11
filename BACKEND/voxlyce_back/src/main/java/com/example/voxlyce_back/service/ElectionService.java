package com.example.voxlyce_back.service;

import com.example.voxlyce_back.dto.ElectionRequest;
import com.example.voxlyce_back.model.*;
import com.example.voxlyce_back.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ElectionService {

    private final ElectionRepository electionRepository;
    private final PositionRepository positionRepository;
    private final ClassroomRepository classroomRepository;
    private final AuditService auditService;

    @Transactional
    public Election createElection(ElectionRequest request) {
        Election election = Election.builder()
                .title(request.getTitle())
                .type(request.getType())
                .status(ElectionStatus.PENDING)
                .positions(new java.util.ArrayList<>())
                .build();

        if (request.getType() == ElectionType.CLASS_VOTE && request.getClassroomId() != null) {
            classroomRepository.findById(request.getClassroomId()).ifPresent(election::setClassroom);
        }

        Election savedElection = electionRepository.save(election);

        if (request.getPositionNames() != null) {
            var positions = request.getPositionNames().stream()
                    .map(name -> Position.builder().name(name).election(savedElection).build())
                    .collect(Collectors.toList());
            var savedPositions = positionRepository.saveAll(positions);
            savedElection.getPositions().addAll(savedPositions);
        }

        auditService.logAction("ELECTION_CREATED", "Created election: " + savedElection.getTitle());
        
        return savedElection;
    }

    public void startElection(Long electionId) {
        Election election = electionRepository.findById(electionId).orElseThrow();
        election.setStatus(ElectionStatus.ONGOING);
        election.setStartTime(LocalDateTime.now());
        election.setEndTime(LocalDateTime.now().plusHours(24));
        electionRepository.save(election);
        auditService.logAction("ELECTION_STARTED", "Election started: " + election.getTitle());
    }

    public void validateResults(Long electionId) {
        Election election = electionRepository.findById(electionId).orElseThrow();
        election.setStatus(ElectionStatus.VALIDATED);
        electionRepository.save(election);
        auditService.logAction("ELECTION_VALIDATED", "Election results validated: " + election.getTitle());
    }
}
