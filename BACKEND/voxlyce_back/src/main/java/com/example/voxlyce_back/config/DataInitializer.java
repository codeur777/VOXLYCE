package com.example.voxlyce_back.config;

import com.example.voxlyce_back.model.Role;
import com.example.voxlyce_back.model.User;
import com.example.voxlyce_back.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) {
        if (!userRepository.existsByEmail("superadmin@voxlyce.com")) {
            User superAdmin = User.builder()
                    .email("superadmin@voxlyce.com")
                    .password(passwordEncoder.encode("admin123"))
                    .firstName("Super")
                    .lastName("Admin")
                    .role(Role.SUPER_ADMIN)
                    .isVerified(true)
                    .twoFactorEnabled(true)
                    .build();
            userRepository.save(superAdmin);
        }

        if (!userRepository.existsByEmail("admin@voxlyce.com")) {
            User admin = User.builder()
                    .email("admin@voxlyce.com")
                    .password(passwordEncoder.encode("admin123"))
                    .firstName("Platform")
                    .lastName("Admin")
                    .role(Role.ADMIN)
                    .isVerified(true)
                    .twoFactorEnabled(true)
                    .build();
            userRepository.save(admin);
        }
    }
}
