package com.example.voxlyce_back.service;

import com.example.voxlyce_back.model.AuditLog;
import com.example.voxlyce_back.model.User;
import com.example.voxlyce_back.repository.AuditLogRepository;
import com.example.voxlyce_back.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class AuditService {

    private final AuditLogRepository auditLogRepository;
    private final UserRepository userRepository;

    public void logAction(String action, String description) {
        String email = SecurityContextHolder.getContext().getAuthentication() != null 
            ? SecurityContextHolder.getContext().getAuthentication().getName() 
            : null;

        User user = null;
        if (email != null && !email.equals("anonymousUser")) {
            user = userRepository.findByEmail(email).orElse(null);
        }

        AuditLog log = AuditLog.builder()
                .action(action)
                .description(description)
                .user(user)
                .timestamp(LocalDateTime.now())
                .build();
        
        auditLogRepository.save(log);
    }
    
    public void logAction(String action, String description, User user) {
        AuditLog log = AuditLog.builder()
                .action(action)
                .description(description)
                .user(user)
                .timestamp(LocalDateTime.now())
                .build();
        
        auditLogRepository.save(log);
    }
}
