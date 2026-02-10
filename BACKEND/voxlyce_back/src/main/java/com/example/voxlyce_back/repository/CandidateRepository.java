package com.example.voxlyce_back.repository;

import com.example.voxlyce_back.model.Candidate;
import com.example.voxlyce_back.model.CandidateStatus;
import com.example.voxlyce_back.model.Position;
import com.example.voxlyce_back.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface CandidateRepository extends JpaRepository<Candidate, Long> {
    List<Candidate> findByPositionAndStatus(Position position, CandidateStatus status);
    List<Candidate> findByStatus(CandidateStatus status);
    List<Candidate> findByUser(User user);
    List<Candidate> findByPositionInAndStatus(List<Position> positions, CandidateStatus status);
    boolean existsByUserAndPosition(User user, Position position);
}
