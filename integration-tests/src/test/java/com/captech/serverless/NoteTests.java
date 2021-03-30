package com.captech.serverless;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import software.amazon.awssdk.services.dynamodb.model.AttributeValue;
import software.amazon.awssdk.services.dynamodb.model.PutItemRequest;

import java.util.HashMap;
import java.util.Map;

import static io.restassured.RestAssured.*;
import static org.hamcrest.Matchers.any;
import static org.hamcrest.Matchers.equalTo;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class NoteTests {

    private final String tableName = System.getenv("TABLE_NAME");

    @BeforeEach
    void setUp() throws Exception {
        baseURI = System.getenv("BASE_URI");
        System.out.println("Table name: " + tableName);
        System.out.println("Base URI: " + baseURI);
        AwsTestUtils.clearTable(tableName);
    }

    @Test
    @Order(1)
    void shouldHaveEmptyNotes() {
        get("/").then()
                .log().body(true)
                .statusCode(200)
                .body("$.size()", equalTo(0));
    }

    @Test
    @Order(2)
    void shouldGetNotes() {
        insertNote("name1", "1");
        insertNote("name2", "2");
        get("/").then()
                .log().body(true)
                .statusCode(200)
                .body("$.size()", equalTo(2))
                .body("[0].name", equalTo("name1"));
    }

    @Test
    @Order(3)
    void shouldCreateNote() {
        Map<String, Object> item = new HashMap<>();
        item.put("name", "name1");
        given().contentType("application/json")
                .body(item)
                .when()
                .post("/")
                .then()
                .log().body(true)
                .body("name", equalTo("name1"))
                .body("pk", any(String.class))
                .body("sk", any(String.class));
    }

    private void insertNote(String name, String sk) {
        Map<String, AttributeValue> item = new HashMap<>();
        item.put("sk", AttributeValue.builder().s(sk).build());
        item.put("pk", AttributeValue.builder().s("Note").build());
        item.put("name", AttributeValue.builder().s(name).build());
        AwsTestUtils.dynamoDbClient.putItem(PutItemRequest.builder()
                .tableName(tableName)
                .item(item)
                .build());
    }
}
