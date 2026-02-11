package com.example.voxlyce_back.repository;

import com.example.voxlyce_back.model.Classroom;
import com.example.voxlyce_back.model.Election;
import com.example.voxlyce_back.model.ElectionStatus;
import com.example.voxlyce_back.model.ElectionType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

public interface ElectionRepository extends JpaRepository<Election, Long> {
    List<Election> findByType(ElectionType type);
    List<Election> findByStatus(ElectionStatus status);
    List<Election> findByClassroom(Classroom classroom);
    
    @Query("SELECT e FROM Election e WHERE e.classroom = :classroom OR e.type = :type")
    List<Election> findByClassroomOrType(@Param("classroom") Classroom classroom, @Param("type") ElectionType type);
    
    @Query("SELECT e FROM Election e LEFT JOIN FETCH e.positions WHERE e.id = :id")
    Election findByIdWithPositions(@Param("id") Long id);
}
