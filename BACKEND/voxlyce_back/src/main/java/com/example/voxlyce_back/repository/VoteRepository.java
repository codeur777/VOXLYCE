package com.example.voxlyce_back.repository;

import com.example.voxlyce_back.model.Vote;
import com.example.voxlyce_back.model.Position;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Map;

public interface VoteRepository extends JpaRepository<Vote, Long> {
    boolean existsByVoterHashAndPosition(String voterHash, Position position);

    @Query("SELECT v.candidate.id AS candidateId, COUNT(v) AS voteCount FROM Vote v WHERE v.position.id = :positionId GROUP BY v.candidate.id")
    List<Map<String, Object>> countVotesByPosition(@Param("positionId") Long positionId);
}
