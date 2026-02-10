package com.example.voxlyce_back.service;

import com.example.voxlyce_back.dto.*;
import com.example.voxlyce_back.model.Role;
import com.example.voxlyce_back.model.User;
import com.example.voxlyce_back.repository.ClassroomRepository;
import com.example.voxlyce_back.repository.UserRepository;
import com.example.voxlyce_back.security.JwtUtil;
import com.example.voxlyce_back.security.TwoFactorAuthService;
import com.example.voxlyce_back.security.UserDetailsImpl;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final ClassroomRepository classroomRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;
    private final AuthenticationManager authenticationManager;
    private final TwoFactorAuthService tfaService;

    public AuthResponse register(RegisterRequest request) {
        var user = User.builder()
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .firstName(request.getFirstName())
                .lastName(request.getLastName())
                .role(request.getRole())
                .isVerified(true) // All users verified by default
                .twoFactorEnabled(false) // Disable 2FA for easier testing
                .build();

        if (request.getClassroomId() != null) {
            classroomRepository.findById(request.getClassroomId()).ifPresent(user::setClassroom);
        }

        userRepository.save(user);
        
        // Generate token immediately
        var jwtToken = jwtUtil.generateToken(new UserDetailsImpl(user));
        
        return AuthResponse.builder()
                .token(jwtToken)
                .email(user.getEmail())
                .role(user.getRole().name())
                .mfaRequired(false)
                .build();
    }

    public AuthResponse authenticate(LoginRequest request) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword())
        );

        var user = userRepository.findByEmail(request.getEmail()).orElseThrow();
        
        // 2FA disabled for easier testing
        var jwtToken = jwtUtil.generateToken(new UserDetailsImpl(user));
        return AuthResponse.builder()
                .token(jwtToken)
                .email(user.getEmail())
                .role(user.getRole().name())
                .mfaRequired(false)
                .build();
    }

    public AuthResponse verifyTwoFactor(TwoFactorRequest request) {
        if (tfaService.verifyOTP(request.getEmail(), request.getCode())) {
            var user = userRepository.findByEmail(request.getEmail()).orElseThrow();
            var jwtToken = jwtUtil.generateToken(new UserDetailsImpl(user));
            return AuthResponse.builder()
                    .token(jwtToken)
                    .email(user.getEmail())
                    .role(user.getRole().name())
                    .mfaRequired(false)
                    .build();
        }
        throw new RuntimeException("Invalid 2FA code");
    }
}
