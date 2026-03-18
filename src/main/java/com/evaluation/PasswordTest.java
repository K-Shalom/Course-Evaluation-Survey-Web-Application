package com.evaluation;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordTest {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        System.out.println("Hash for 'admin': " + encoder.encode("admin"));
        System.out.println("Hash for 'Admin@1234': " + encoder.encode("Admin@1234"));
    }
}
