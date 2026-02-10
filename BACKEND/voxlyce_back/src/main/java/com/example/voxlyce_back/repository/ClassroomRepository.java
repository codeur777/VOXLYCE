package com.example.voxlyce_back.repository;

import com.example.voxlyce_back.model.Classroom;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface ClassroomRepository extends JpaRepository<Classroom, Long> {
    Optional<Classroom> findByName(String name);
}
