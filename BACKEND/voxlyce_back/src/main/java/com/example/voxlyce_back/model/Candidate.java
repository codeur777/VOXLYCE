package com.example.voxlyce_back.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "candidates", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"user_id", "position_id"})
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Candidate {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "position_id", nullable = false)
    private Position position;

    @Column(columnDefinition = "TEXT")
    private String manifesto;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private CandidateStatus status = CandidateStatus.PENDING;

    // Photo de la carte d'étudiant (optionnel)
    @Column(name = "student_card_photo_url")
    private String studentCardPhotoUrl;

    // Frais de dépôt
    @Column(name = "deposit_fee_paid", nullable = false)
    private Boolean depositFeePaid = false;

    @Column(name = "deposit_fee_amount")
    private Double depositFeeAmount = 500.0; // 500F par défaut

    @Column(name = "payment_reference")
    private String paymentReference;

    @Column(name = "payment_date")
    private java.time.LocalDateTime paymentDate;
}
