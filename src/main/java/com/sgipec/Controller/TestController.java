package com.sgipec.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class TestController {

    @GetMapping("/saludo")
    public String saludar() {
        return "¡Hola! El backend del SGIPEC está funcionando correctamente.";
    }
}
