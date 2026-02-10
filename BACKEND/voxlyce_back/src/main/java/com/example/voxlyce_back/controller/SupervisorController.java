package com.example.voxlyce_back.controller;

import com.example.voxlyce_back.repository.UserRepository;
import com.example.voxlyce_back.service.ElectionService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/supervisor")
@RequiredArgsConstructor
@SecurityRequirement(name = "bearerAuth")
@Tag(name = "Supervisor", description = "Endpoints for class supervisors")
public class SupervisorController {

    private final ElectionService electionService;
    private final UserRepository userRepository;

    @PostMapping("/elections/{id}/start")
    @PreAuthorize("hasRole('SUPERVISOR')")
    @Operation(summary = "Start an election (triggers 24h timer)")
    public ResponseEntity<?> startElection(@PathVariable Long id) {
        electionService.startElection(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/elections/{id}/elector-count")
    @PreAuthorize("hasRole('SUPERVISOR')")
    @Operation(summary = "Check count of registered students for an election context")
    public ResponseEntity<Long> getElectorCount(@PathVariable Long id) {
        // Mocking elector count logic - in real scenario, link to classroom/election
        return ResponseEntity.ok(userRepository.count());
    }
}
