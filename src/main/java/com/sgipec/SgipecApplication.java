package com.sgipec;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan(basePackages = "com.sgipec") // Esto obliga a buscar en todas las subcarpetas
public class SgipecApplication {
    public static void main(String[] args) {
        SpringApplication.run(SgipecApplication.class, args);
    }
}
