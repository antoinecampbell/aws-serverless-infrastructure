package com.captech.serverless;

import software.amazon.awssdk.services.dynamodb.DynamoDbClient;
import software.amazon.awssdk.services.dynamodb.model.CreateTableRequest;
import software.amazon.awssdk.services.dynamodb.model.DeleteTableRequest;
import software.amazon.awssdk.services.dynamodb.model.DescribeTableRequest;
import software.amazon.awssdk.services.dynamodb.model.DescribeTableResponse;
import software.amazon.awssdk.services.dynamodb.model.ResourceNotFoundException;
import software.amazon.awssdk.services.dynamodb.model.TableStatus;

public final class AwsTestUtils {
    public static final DynamoDbClient dynamoDbClient;

    static {
        dynamoDbClient = DynamoDbClient.create();
    }

    /**
     * Clear all values by deleting and recreating the table
     */
    public static void clearTable(String tableName) throws Exception {
        final DescribeTableResponse describeTableResponse = dynamoDbClient.describeTable(DescribeTableRequest.builder()
                .tableName(tableName)
                .build());
        dynamoDbClient.deleteTable(DeleteTableRequest.builder()
                .tableName(tableName)
                .build());

        boolean tableFound = true;
        while (tableFound) {
            try {
                dynamoDbClient.describeTable(DescribeTableRequest.builder()
                        .tableName(tableName)
                        .build());
                System.out.println("Waiting for table to be deleted...");
                Thread.sleep(1000);
            } catch (ResourceNotFoundException e) {
                tableFound = false;
                System.out.println("Table deleted");
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

        System.out.println("Creating table");
        dynamoDbClient.createTable(CreateTableRequest.builder()
                .tableName(tableName)
                .keySchema(describeTableResponse.table().keySchema())
                .billingMode(describeTableResponse.table().billingModeSummary().billingMode())
                .attributeDefinitions(describeTableResponse.table().attributeDefinitions())
                .build());

        tableFound = false;
        while (!tableFound) {
            try {
                DescribeTableResponse response = dynamoDbClient.describeTable(DescribeTableRequest.builder()
                        .tableName(tableName)
                        .build());
                if (response.table().tableStatus() != TableStatus.ACTIVE) {
                    System.out.println("Waiting for table to become active...");
                    Thread.sleep(1000);
                } else {
                    tableFound = true;
                    System.out.println("Table created");
                }
            } catch (ResourceNotFoundException e) {
                System.out.println("Table not found, sleeping before trying again");
            }
        }
    }
}
