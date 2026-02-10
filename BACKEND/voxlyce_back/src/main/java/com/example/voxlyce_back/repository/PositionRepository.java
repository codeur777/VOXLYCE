package com.example.voxlyce_back.repository;

import com.example.voxlyce_back.model.Position;
import com.example.voxlyce_back.model.Election;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface PositionRepository extends JpaRepository<Position, Long> {
    List<Position> findByElection(Election election);
}
