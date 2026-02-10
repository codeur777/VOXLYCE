package com.example.voxlyce_back.dto;

import com.example.voxlyce_back.model.Role;
import lombok.Data;

@Data
public class RegisterRequest {
    private String email;
    private String password;
    private String firstName;
    private String lastName;
    private Role role;
    private Long classroomId; // Optional, for students
}
