package com.evaluation.config;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Collection;

/**
 * After successful login, redirect each role to its own dashboard.
 */
public class RoleBasedAuthSuccessHandler implements AuthenticationSuccessHandler {

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request,
                                        HttpServletResponse response,
                                        Authentication authentication) throws IOException {
        String targetUrl = determineTargetUrl(authentication);
        response.sendRedirect(request.getContextPath() + targetUrl);
    }

    private String determineTargetUrl(Authentication authentication) {
        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
        for (GrantedAuthority authority : authorities) {
            switch (authority.getAuthority()) {
                case "ROLE_ADMIN":     return "/admin/dashboard";
                case "ROLE_INITIATOR": return "/initiator/dashboard";
                case "ROLE_TEACHER":   return "/teacher/dashboard";
                case "ROLE_RESPONDENT":return "/respondent/surveys";
            }
        }
        return "/home";
    }
}
