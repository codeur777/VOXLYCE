package com.example.voxlyce_back.controller;

import com.example.voxlyce_back.dto.*;
import com.example.voxlyce_back.model.*;
import com.example.voxlyce_back.repository.*;
import com.example.voxlyce_back.service.AuditService;
import com.example.voxlyce_back.service.MappingService;
import com.example.voxlyce_back.service.VotingService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/v1/student")
@RequiredArgsConstructor
@SecurityRequirement(name = "bearerAuth")
@Tag(name = "Student/Elector", description = "Endpoints for students to vote or apply as candidates")
public class ElectorController {

    private final VotingService votingService;
    private final CandidateRepository candidateRepository;
    private final UserRepository userRepository;
    private final PositionRepository positionRepository;
    private final ElectionRepository electionRepository;
    private final AuditService auditService;
    private final MappingService mappingService;

    // ========== CANDIDATURE ==========
    
    @PostMapping("/candidates")
    @PreAuthorize("hasRole('STUDENT')")
    @Operation(summary = "S'inscrire comme candidat pour un poste")
    public ResponseEntity<CandidateResponse> applyAsCandidate(@RequestBody CandidateRequest request) {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = userRepository.findByEmail(email).orElseThrow(() -> new RuntimeException("User not found"));
        
        if (!user.isVerified()) {
            throw new RuntimeException("Your account must be verified to apply as candidate");
        }
        
        Position position = positionRepository.findById(request.getPositionId())
                .orElseThrow(() -> new RuntimeException("Position not found"));
        
        // Vérifier si l'étudiant a déjà postulé pour ce poste
        if (candidateRepository.existsByUserAndPosition(user, position)) {
            throw new RuntimeException("You have already applied for this position");
        }
        
        Candidate candidate = Candidate.builder()
                .user(user)
                .position(position)
                .manifesto(request.getManifesto())
                .status(CandidateStatus.PENDING)
                .build();
        
        candidateRepository.save(candidate);
        auditService.logAction("CANDIDATE_APPLICATION", 
            "User " + email + " applied for position: " + position.getName(), user);
        
        return ResponseEntity.ok(mappingService.toCandidateResponse(candidate));
    }

    @GetMapping("/candidates/my-candidatures")
    @PreAuthorize("hasRole('STUDENT')")
    @Operation(summary = "Mes candidatures")
    public ResponseEntity<List<CandidateResponse>> getMyCandidatures() {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = userRepository.findByEmail(email).orElseThrow(() -> new RuntimeException("User not found"));
        
        List<Candidate> candidates = candidateRepository.findByUser(user);
        List<CandidateResponse> responses = candidates.stream()
                .map(mappingService::toCandidateResponse)
                .collect(Collectors.toList());
        
        return ResponseEntity.ok(responses);
    }

    @PutMapping("/candidates/{id}")
    @PreAuthorize("hasRole('STUDENT')")
    @Operation(summary = "Modifier ma candidature")
    public ResponseEntity<CandidateResponse> updateCandidature(@PathVariable Long id, @RequestBody CandidateRequest request) {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = userRepository.findByEmail(email).orElseThrow(() -> new RuntimeException("User not found"));
        
        Candidate candidate = candidateRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Candidate not found"));
        
        if (!candidate.getUser().getId().equals(user.getId())) {
            throw new RuntimeException("You can only update your own candidature");
        }
        
        if (candidate.getStatus() != CandidateStatus.PENDING) {
            throw new RuntimeException("You can only update pending candidatures");
        }
        
        candidate.setManifesto(request.getManifesto());
        candidateRepository.save(candidate);
        
        auditService.logAction("CANDIDATE_UPDATE", 
            "User " + email + " updated candidature for position: " + candidate.getPosition().getName(), user);
        
        return ResponseEntity.ok(mappingService.toCandidateResponse(candidate));
    }

    @DeleteMapping("/candidates/{id}")
    @PreAuthorize("hasRole('STUDENT')")
    @Operation(summary = "Retirer ma candidature")
    public ResponseEntity<?> withdrawCandidature(@PathVariable Long id) {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = userRepository.findByEmail(email).orElseThrow(() -> new RuntimeException("User not found"));
        
        Candidate candidate = candidateRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Candidate not found"));
        
        if (!candidate.getUser().getId().equals(user.getId())) {
            throw new RuntimeException("You can only withdraw your own candidature");
        }
        
        candidate.setStatus(CandidateStatus.WITHDRAWN);
        candidateRepository.save(candidate);
        
        auditService.logAction("CANDIDATE_WITHDRAWN", 
            "User " + email + " withdrew candidature for position: " + candidate.getPosition().getName(), user);
        
        return ResponseEntity.ok().build();
    }

    // ========== ÉLECTIONS ==========
    
    @GetMapping("/elections")
    @PreAuthorize("hasRole('STUDENT')")
    @Operation(summary = "Liste des élections disponibles pour voter")
    public ResponseEntity<List<ElectionResponse>> getAvailableElections() {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = userRepository.findByEmail(email).orElseThrow(() -> new RuntimeException("User not found"));
        
        List<Election> elections;
        if (user.getClassroom() != null) {
            // Élections de classe + élections du comité
            elections = electionRepository.findByClassroomOrType(user.getClassroom(), ElectionType.COMMITTEE_VOTE);
        } else {
            // Seulement les élections du comité
            elections = electionRepository.findByType(ElectionType.COMMITTEE_VOTE);
        }
        
        // Filtrer les élections en cours ou validées
        elections = elections.stream()
                .filter(e -> e.getStatus() == ElectionStatus.ONGOING || e.getStatus() == ElectionStatus.VALIDATED)
                .collect(Collectors.toList());
        
        List<ElectionResponse> responses = elections.stream()
                .map(mappingService::toElectionResponse)
                .collect(Collectors.toList());
        
        return ResponseEntity.ok(responses);
    }

    @GetMapping("/elections/{id}")
    @PreAuthorize("hasRole('STUDENT')")
    @Operation(summary = "Détails d'une élection")
    public ResponseEntity<ElectionResponse> getElection(@PathVariable Long id) {
        Election election = electionRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Election not found"));
        
        return ResponseEntity.ok(mappingService.toElectionResponse(election));
    }

    @GetMapping("/elections/{id}/candidates")
    @PreAuthorize("hasRole('STUDENT')")
    @Operation(summary = "Liste des candidats acceptés pour une élection")
    public ResponseEntity<List<CandidateResponse>> getElectionCandidates(@PathVariable Long id) {
        Election election = electionRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Election not found"));
        
        List<Candidate> candidates = candidateRepository.findByPositionInAndStatus(
                election.getPositions(), CandidateStatus.ACCEPTED);
        
        List<CandidateResponse> responses = candidates.stream()
                .map(mappingService::toCandidateResponse)
                .collect(Collectors.toList());
        
        return ResponseEntity.ok(responses);
    }

    // ========== VOTE ==========
    
    @PostMapping("/vote")
    @PreAuthorize("hasRole('STUDENT')")
    @Operation(summary = "Voter pour un candidat")
    public ResponseEntity<?> castVote(@RequestBody VoteRequest request) {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = userRepository.findByEmail(email).orElseThrow(() -> new RuntimeException("User not found"));
        
        if (!user.isVerified()) {
            throw new RuntimeException("Your account must be verified to vote");
        }
        
        votingService.castVote(request);
        auditService.logAction("VOTE_CAST", 
            "User voted in election " + request.getElectionId() + " for position " + request.getPositionId(), user);
        
        return ResponseEntity.ok().build();
    }

    @GetMapping("/elections/{id}/voting-status")
    @PreAuthorize("hasRole('STUDENT')")
    @Operation(summary = "Vérifier si j'ai déjà voté pour chaque poste")
    public ResponseEntity<VotingStatusResponse> getVotingStatus(@PathVariable Long id) {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        
        VotingStatusResponse status = votingService.getVotingStatus(id, email);
        return ResponseEntity.ok(status);
    }

    // ========== RÉSULTATS ==========
    
    @GetMapping("/elections/{id}/results")
    @PreAuthorize("hasRole('STUDENT')")
    @Operation(summary = "Voir les résultats validés d'une élection")
    public ResponseEntity<ElectionResult> getElectionResults(@PathVariable Long id) {
        Election election = electionRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Election not found"));
        
        if (election.getStatus() != ElectionStatus.VALIDATED) {
            throw new RuntimeException("Results are not yet validated");
        }
        
        ElectionResult result = votingService.calculateResults(id);
        return ResponseEntity.ok(result);
    }

    @GetMapping("/elections/history")
    @PreAuthorize("hasRole('STUDENT')")
    @Operation(summary = "Historique de toutes les élections validées")
    public ResponseEntity<List<ElectionResponse>> getElectionsHistory() {
        List<Election> elections = electionRepository.findByStatus(ElectionStatus.VALIDATED);
        
        List<ElectionResponse> responses = elections.stream()
                .map(mappingService::toElectionResponse)
                .collect(Collectors.toList());
        
        return ResponseEntity.ok(responses);
    }
}
