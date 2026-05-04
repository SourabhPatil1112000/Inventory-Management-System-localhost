package com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.config;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SwaggerConfig {

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("Patil Batteries & Power Solutions API")
                        .description("API documentation for Shop Management System - Batteries and Power Solutions")
                        .version("1.0")
                        .contact(new Contact()
                                .name("Sourabh Patil")
                                .email("patilsourabhsatish@gmail.com")
                                .url("https://github.com/SourabhPatil1112000")
                        )
                        .license(new License()
                                .name("Apache 2.0")
                                .url("http://springdoc.org")
                        )
                )
                // Add security requirement for JWT (if you implement JWT)
                .addSecurityItem(new SecurityRequirement().addList("BearerAuth"))
                // Define the security scheme
                .components(new Components()
                        .addSecuritySchemes("BearerAuth",
                                new SecurityScheme()
                                        .name("BearerAuth")
                                        .type(SecurityScheme.Type.HTTP)
                                        .scheme("bearer")
                                        .bearerFormat("JWT")
                                        .description("Enter JWT token as: Bearer <your-token>")
                        )
                );
    }
}