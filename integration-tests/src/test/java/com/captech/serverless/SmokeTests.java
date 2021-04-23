package com.captech.serverless;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;

import static io.restassured.RestAssured.baseURI;
import static io.restassured.RestAssured.get;

@Tag("smoke-test")
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class SmokeTests {

    @BeforeEach
    void setUp() {
        baseURI = System.getenv("BASE_URI");
        System.out.println("Base URI: " + baseURI);
    }

    @Test
    @Order(1)
    void shouldGetNotes() {
        get("/").then()
                .log().body(true)
                .statusCode(200);
    }
}
