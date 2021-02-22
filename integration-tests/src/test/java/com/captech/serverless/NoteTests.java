package com.captech.serverless;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import software.amazon.awssdk.services.dynamodb.model.AttributeValue;
import software.amazon.awssdk.services.dynamodb.model.PutItemRequest;

import java.util.HashMap;
import java.util.Map;

import static io.restassured.RestAssured.baseURI;
import static io.restassured.RestAssured.get;
import static org.hamcrest.Matchers.equalTo;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class NoteTests {

    private final String tableName = System.getenv("TABLE_NAME");

    @BeforeEach
    void setUp() {
        baseURI = System.getenv("BASE_URI");
        System.out.println("Table name: " + tableName);
        System.out.println("Base URI: " + baseURI);
    }

    @AfterEach
    void tearDown() throws Exception {
        AwsTestUtils.clearTable(tableName);
    }

    @Test
    @Order(1)
    void shouldHaveEmptyNotes() {
        get("/notes").then()
                .log().body(true)
                .statusCode(200)
                .body("$.size()", equalTo(0));
    }

    @Test
    @Order(2)
    void shouldGetNotes() {
        insertNote("name1", "1");
        insertNote("name2", "2");
        get("/notes").then()
                .log().body(true)
                .statusCode(200)
                .body("$.size()", equalTo(2))
                .body("[0].name", equalTo("name1"));
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
