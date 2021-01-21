const {DynamoDBClient, QueryCommand, PutItemCommand} = require('@aws-sdk/client-dynamodb');
const {marshall, unmarshall} = require('@aws-sdk/util-dynamodb');
const {v4: uuidv4} = require('uuid');

module.exports = class NoteRepository {

  constructor() {
    this.client = new DynamoDBClient({
      region: process.env['AWS_REGION'] || 'us-east-1',
    });
    this.tableName = process.env['TABLE_NAME'] || 'notes';
  }

  getNotes() {
    return this.client.send(new QueryCommand({
      TableName: this.tableName,
      KeyConditionExpression: 'pk = :note',
      ExpressionAttributeValues: {':note': {'S': 'Note'}}
    })).then(response => response.Items && response.Items.map(item => unmarshall(item)) || []);
  }

  createNote(note) {
    return this.client.send(new PutItemCommand({
      TableName: this.tableName,
      Item: marshall({
        ...note,
        pk: 'Note',
        sk: `${Date.now()}#${uuidv4()}`
      }),
    }))
  }
}
