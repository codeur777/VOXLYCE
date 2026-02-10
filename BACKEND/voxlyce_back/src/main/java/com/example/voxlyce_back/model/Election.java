package com.example.voxlyce_back.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "elections")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Election {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String title;

    @Enumerated(EnumType.STRING)
    private ElectionType type;

    @Enumerated(EnumType.STRING)
    private ElectionStatus status = ElectionStatus.PENDING;

    private LocalDateTime startTime;
    private LocalDateTime endTime;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "classroom_id")
    private Classroom classroom; // Null for committee votes

    @OneToMany(mappedBy = "election", cascade = CascadeType.ALL)
    private List<Position> positions;
}
