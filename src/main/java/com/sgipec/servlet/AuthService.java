package com.ejemplo.sgipec.service;

import com.ejemplo.sgipec.model.User;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class AuthService {
    // Simulando una base de datos en memoria
    private Map<String, String> userDatabase = new HashMap<>();

    // Método para registrar un nuevo usuario
    public String register(User user) {
        if (userDatabase.containsKey(user.getUsername())) {
            return "El usuario ya existe.";
        }
        userDatabase.put(user.getUsername(), user.getPassword());
        return "Registro exitoso.";
    }

    // Método para iniciar sesión
    public String login(User user) {
        String storedPassword = userDatabase.get(user.getUsername());
        if (storedPassword != null && storedPassword.equals(user.getPassword())) {
            return "Autenticación satisfactoria.";
        }
        return "Error en la autenticación.";
    }
}
