package com.example.voxlyce_back.controller;

import com.example.voxlyce_back.dto.ElectionResult;
import com.example.voxlyce_back.model.Election;
import com.example.voxlyce_back.repository.ElectionRepository;
import com.example.voxlyce_back.service.VotingService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/elections")
@RequiredArgsConstructor
@Tag(name = "Elections", description = "Public endpoints to view elections and results")
public class ElectionController {

    private final ElectionRepository electionRepository;
    private final VotingService votingService;

    @GetMapping
    @Operation(summary = "Get all elections")
    public ResponseEntity<List<Election>> getAllElections() {
        return ResponseEntity.ok(electionRepository.findAll());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get election details")
    public ResponseEntity<Election> getElection(@PathVariable Long id) {
        return ResponseEntity.ok(electionRepository.findById(id).orElseThrow());
    }

    @GetMapping("/{id}/results")
    @Operation(summary = "Get election results (visible after completion or if validated)")
    public ResponseEntity<ElectionResult> getResults(@PathVariable Long id) {
        return ResponseEntity.ok(votingService.calculateResults(id));
    }
}
