package com.example.voxlyce_back.security;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.security.SecureRandom;
import java.util.concurrent.ConcurrentHashMap;
import java.util.Map;

@Service
@Slf4j
public class TwoFactorAuthService {

    private final Map<String, String> otpStorage = new ConcurrentHashMap<>();
    private final SecureRandom secureRandom = new SecureRandom();

    public String generateOTP(String email) {
        String otp = String.format("%06d", secureRandom.nextInt(1000000));
        otpStorage.put(email, otp);
        log.info("OTP for {}: {}", email, otp); // In production, send via email service
        return otp;
    }

    public boolean verifyOTP(String email, String otp) {
        String storedOtp = otpStorage.get(email);
        if (storedOtp != null && storedOtp.equals(otp)) {
            otpStorage.remove(email);
            return true;
        }
        return false;
    }
}
