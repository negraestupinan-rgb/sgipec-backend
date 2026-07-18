package com.sgipec.service;

import com.sgipec.model.User;
import org.springframework.stereotype.Service;
import java.util.HashMap;
import java.util.Map;

@Service
public class AuthService {

    // Simulación de base de datos en memoria
    private Map<String, String> userDatabase = new HashMap<>();

    public String register(User user) {
        userDatabase.put(user.getUsername(), user.getPassword());
        return "Usuario registrado: " + user.getUsername();
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
