package com.sgipec.Controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/productos") // Esta es la ruta base de tu API
public class ProductoController {

    @GetMapping("/saludo") // La ruta completa será: /api/productos/saludo
    public String saludar() {
        return "¡Hola! Tu API de CodeSight está funcionando correctamente.";
    }
}
