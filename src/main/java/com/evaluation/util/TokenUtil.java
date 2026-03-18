package com.evaluation.util;

import java.security.SecureRandom;
import java.util.Base64;
import java.util.UUID;

public class TokenUtil {

    private static final SecureRandom RANDOM = new SecureRandom();

    /** Generates a URL-safe random token (32 bytes → 43 chars Base64url) */
    public static String generateToken() {
        byte[] bytes = new byte[32];
        RANDOM.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    /** Generates a UUID submission ID */
    public static String generateSubmissionId() {
        return UUID.randomUUID().toString();
    }

    private TokenUtil() {}
}
