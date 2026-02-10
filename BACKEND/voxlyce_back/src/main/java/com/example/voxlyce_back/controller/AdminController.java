package com.example.voxlyce_back.controller;

import com.example.voxlyce_back.dto.CandidateRequest;
import com.example.voxlyce_back.dto.ElectionRequest;
import com.example.voxlyce_back.model.Candidate;
import com.example.voxlyce_back.model.CandidateStatus;
import com.example.voxlyce_back.repository.CandidateRepository;
import com.example.voxlyce_back.service.AuditService;
import com.example.voxlyce_back.service.ElectionService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/admin")
@RequiredArgsConstructor
@SecurityRequirement(name = "bearerAuth")
@Tag(name = "Admin", description = "Endpoints for SuperAdmin and Admin management")
public class AdminController {

    private final ElectionService electionService;
    private final CandidateRepository candidateRepository;
    private final AuditService auditService;

    @PostMapping("/elections")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN', 'ADMIN')")
    @Operation(summary = "Create a new election and its positions")
    public ResponseEntity<?> createElection(@RequestBody ElectionRequest request) {
        return ResponseEntity.ok(electionService.createElection(request));
    }

    @GetMapping("/candidates/pending")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN', 'ADMIN')")
    @Operation(summary = "Get list of candidates pending validation")
    public ResponseEntity<List<Candidate>> getPendingCandidates() {
        return ResponseEntity.ok(candidateRepository.findByStatus(CandidateStatus.PENDING));
    }

    @PutMapping("/candidates/{id}/status")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN', 'ADMIN')")
    @Operation(summary = "Accept or Reject a candidate")
    public ResponseEntity<?> validateCandidate(@PathVariable Long id, @RequestParam CandidateStatus status) {
        Candidate candidate = candidateRepository.findById(id).orElseThrow();
        candidate.setStatus(status);
        candidateRepository.save(candidate);
        auditService.logAction("CANDIDATE_VALIDATION", "Status " + status + " for candidate " + candidate.getUser().getEmail());
        return ResponseEntity.ok().build();
    }

    @PostMapping("/elections/{id}/validate-results")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN', 'ADMIN')")
    @Operation(summary = "Validate final results to make them public")
    public ResponseEntity<?> validateElectionResults(@PathVariable Long id) {
        electionService.validateResults(id);
        return ResponseEntity.ok().build();
    }
}
