package com.ejemplo.sgipec.controller;

import com.ejemplo.sgipec.model.User;
import com.ejemplo.sgipec.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
public class AuthController {

    @Autowired
    private AuthService authService;

    // Endpoint para registrar un nuevo usuario
    @PostMapping("/register")
    public String register(@RequestBody User user) {
        return authService.register(user);
    }

    // Endpoint para iniciar sesión
    @PostMapping("/login")
    public String login(@RequestBody User user) {
        return authService.login(user);
    }
}
