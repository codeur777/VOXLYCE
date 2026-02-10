package com.example.voxlyce_back.service;

import com.example.voxlyce_back.dto.ElectionResult;
import com.example.voxlyce_back.dto.VoteRequest;
import com.example.voxlyce_back.dto.VotingStatusResponse;
import com.example.voxlyce_back.model.*;
import com.example.voxlyce_back.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class VotingService {

    private final VoteRepository voteRepository;
    private final ElectionRepository electionRepository;
    private final PositionRepository positionRepository;
    private final CandidateRepository candidateRepository;

    @Transactional
    public void castVote(VoteRequest request) {
        Election election = electionRepository.findById(request.getElectionId())
                .orElseThrow(() -> new RuntimeException("Election not found"));
                
        if (election.getStatus() != ElectionStatus.ONGOING) {
            throw new RuntimeException("Election is not currently ongoing");
        }

        if (LocalDateTime.now().isAfter(election.getEndTime())) {
            election.setStatus(ElectionStatus.COMPLETED);
            electionRepository.save(election);
            throw new RuntimeException("Election time has expired");
        }

        String userEmail = SecurityContextHolder.getContext().getAuthentication().getName();
        String voterHash = generateVoterHash(userEmail, election.getId());

        Position position = positionRepository.findById(request.getPositionId())
                .orElseThrow(() -> new RuntimeException("Position not found"));
                
        if (voteRepository.existsByVoterHashAndPosition(voterHash, position)) {
            throw new RuntimeException("You have already voted for this position");
        }

        Candidate candidate = candidateRepository.findById(request.getCandidateId())
                .orElseThrow(() -> new RuntimeException("Candidate not found"));
        
        if (candidate.getStatus() != CandidateStatus.ACCEPTED) {
            throw new RuntimeException("This candidate is not accepted");
        }
        
        Vote vote = Vote.builder()
                .voterHash(voterHash)
                .candidate(candidate)
                .position(position)
                .timestamp(LocalDateTime.now())
                .build();

        voteRepository.save(vote);
    }

    public VotingStatusResponse getVotingStatus(Long electionId, String email) {
        Election election = electionRepository.findById(electionId)
                .orElseThrow(() -> new RuntimeException("Election not found"));
        
        String voterHash = generateVoterHash(email, electionId);
        
        Map<Long, Boolean> votedByPosition = new HashMap<>();
        for (Position position : election.getPositions()) {
            boolean hasVoted = voteRepository.existsByVoterHashAndPosition(voterHash, position);
            votedByPosition.put(position.getId(), hasVoted);
        }
        
        return VotingStatusResponse.builder()
                .electionId(electionId)
                .votedByPosition(votedByPosition)
                .build();
    }

    public ElectionResult calculateResults(Long electionId) {
        Election election = electionRepository.findById(electionId)
                .orElseThrow(() -> new RuntimeException("Election not found"));
        List<Position> positions = positionRepository.findByElection(election);

        Map<String, Map<String, Long>> resultsByPosition = new HashMap<>();
        boolean overallTie = false;

        for (Position pos : positions) {
            List<Map<String, Object>> voteCounts = voteRepository.countVotesByPosition(pos.getId());
            Map<String, Long> candidateResults = new HashMap<>();

            long maxVotes = -1;
            int winnersCount = 0;

            for (Map<String, Object> count : voteCounts) {
                Long candidateId = (Long) count.get("candidateId");
                Long voteCount = (Long) count.get("voteCount");
                Candidate candidate = candidateRepository.findById(candidateId)
                        .orElseThrow(() -> new RuntimeException("Candidate not found"));
                candidateResults.put(candidate.getUser().getFirstName() + " " + candidate.getUser().getLastName(), voteCount);

                if (voteCount > maxVotes) {
                    maxVotes = voteCount;
                    winnersCount = 1;
                } else if (voteCount == maxVotes) {
                    winnersCount++;
                }
            }
            resultsByPosition.put(pos.getName(), candidateResults);
            if (winnersCount > 1 && maxVotes > 0) {
                overallTie = true;
            }
        }

        if (overallTie && election.getStatus() != ElectionStatus.VALIDATED) {
            election.setStatus(ElectionStatus.TIE);
            electionRepository.save(election);
        }

        return ElectionResult.builder()
                .electionId(electionId)
                .resultsByPosition(resultsByPosition)
                .hasTie(overallTie)
                .build();
    }

    private String generateVoterHash(String email, Long electionId) {
        try {
            String combined = email + ":" + electionId;
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(combined.getBytes(StandardCharsets.UTF_8));
            return Base64.getEncoder().encodeToString(hash);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error generating voter hash", e);
        }
    }
}
