package com.example.voxlyce_back.controller;

import com.example.voxlyce_back.dto.*;
import com.example.voxlyce_back.service.AuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
@Tag(name = "Authentication", description = "Endpoints for user login, registration, and 2FA")
public class AuthController {

    private final AuthService authService;

    @PostMapping("/register")
    @Operation(summary = "Register a new user (Student, Admin, or Supervisor)")
    public ResponseEntity<AuthResponse> register(@RequestBody RegisterRequest request) {
        return ResponseEntity.ok(authService.register(request));
    }

    @PostMapping("/login")
    @Operation(summary = "Login with email and password. May require 2FA.")
    public ResponseEntity<AuthResponse> authenticate(@RequestBody LoginRequest request) {
        return ResponseEntity.ok(authService.authenticate(request));
    }

    @PostMapping("/verify-2fa")
    @Operation(summary = "Verify 2FA code to receive JWT token")
    public ResponseEntity<AuthResponse> verifyTwoFactor(@RequestBody TwoFactorRequest request) {
        return ResponseEntity.ok(authService.verifyTwoFactor(request));
    }
}
